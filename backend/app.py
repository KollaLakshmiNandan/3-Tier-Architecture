import os
from functools import wraps
from decimal import Decimal, InvalidOperation
from flask import Flask, request, jsonify, session
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

secret_key = os.getenv("FLASK_SECRET_KEY")
if not secret_key:
    raise RuntimeError("FLASK_SECRET_KEY environment variable is required")

app.secret_key = secret_key
app.config.update(
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE="Lax",
    SESSION_COOKIE_SECURE=False,  # Local HTTP development only
)

CORS(app, origins=["http://localhost:5173"], supports_credentials=True)

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "database": os.getenv("DB_NAME", "claimsdb"),
    "user": os.getenv("DB_USER", "claimsuser"),
    "password": os.getenv("DB_PASSWORD", ""),
    "port": int(os.getenv("DB_PORT", "5432")),
}


def get_db():
    return psycopg2.connect(**DB_CONFIG)


def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if not session.get("user_id"):
            return jsonify({"error": "Please log in"}), 401
        return func(*args, **kwargs)
    return wrapper


@app.route("/api/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "claims-backend",
        "version": "3.0",
    })


@app.route("/api/claims", methods=["GET"])
@login_required
def get_claims():
    try:
        with get_db() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    SELECT id, claim_number, customer_name, amount,
                           description, status, created_at
                    FROM claims
                    WHERE user_id = %s
                    ORDER BY id DESC
                """, (session["user_id"],))
                claims = cur.fetchall()

        return jsonify(claims)

    except Exception:
        app.logger.exception("Failed to fetch claims")
        return jsonify({"error": "Unable to fetch claims"}), 500


@app.route("/api/claims", methods=["POST"])
@login_required
def create_claim():
    data = request.get_json(silent=True) or {}
    customer_name = data.get("customer_name")
    amount = data.get("amount")
    description = data.get("description")

    if not customer_name or amount in (None, ""):
        return jsonify({
            "error": "Customer name and amount are required"
        }), 400

    try:
        with get_db() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    INSERT INTO claims
                        (customer_name, amount, description, user_id)
                    VALUES (%s, %s, %s, %s)
                    RETURNING id, claim_number, customer_name,
                              amount, description, status, created_at
                """, (
                    customer_name,
                    amount,
                    description,
                    session["user_id"],
                ))
                claim = cur.fetchone()

        return jsonify(claim), 201

    except Exception:
        app.logger.exception("Failed to create claim")
        return jsonify({"error": "Unable to create claim"}), 500


@app.route("/api/claims/<int:claim_id>", methods=["PUT"])
@login_required
def update_claim(claim_id):
    data = request.get_json(silent=True) or {}
    status = data.get("status")

    if status not in ["Pending", "Approved", "Rejected"]:
        return jsonify({"error": "Invalid status"}), 400

    try:
        with get_db() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    UPDATE claims
                    SET status = %s
                    WHERE id = %s AND user_id = %s
                    RETURNING id, claim_number, customer_name,
                              amount, description, status, created_at
                """, (status, claim_id, session["user_id"]))
                claim = cur.fetchone()

        if not claim:
            return jsonify({"error": "Claim not found"}), 404

        return jsonify(claim)

    except Exception:
        app.logger.exception("Failed to update claim")
        return jsonify({"error": "Unable to update claim"}), 500


@app.route("/api/register", methods=["POST"])
def register():
    data = request.get_json(silent=True) or {}
    name = data.get("name")
    email = data.get("email")
    password = data.get("password")

    if not name or not email or not password:
        return jsonify({"error": "All fields are required"}), 400

    conn = None
    try:
        conn = get_db()
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            password_hash = generate_password_hash(password)
            cur.execute("""
                INSERT INTO users (name, email, password_hash)
                VALUES (%s, %s, %s)
                RETURNING id, name, email
            """, (name, email, password_hash))
            user = cur.fetchone()
        conn.commit()
        return jsonify(user), 201

    except psycopg2.errors.UniqueViolation:
        if conn:
            conn.rollback()
        return jsonify({"error": "Email already registered"}), 409

    except Exception:
        if conn:
            conn.rollback()
        app.logger.exception("Failed to register user")
        return jsonify({"error": "Unable to register user"}), 500

    finally:
        if conn:
            conn.close()


@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json(silent=True) or {}
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({
            "error": "Email and password are required"
        }), 400

    try:
        with get_db() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    SELECT id, name, email, password_hash
                    FROM users
                    WHERE email = %s
                """, (email,))
                user = cur.fetchone()

        if not user or not check_password_hash(
            user["password_hash"], password
        ):
            return jsonify({
                "error": "Invalid email or password"
            }), 401

        session.clear()
        session["user_id"] = user["id"]
        session["user_name"] = user["name"]
        session["user_email"] = user["email"]

        return jsonify({
            "message": "Login successful",
            "user": {
                "id": user["id"],
                "name": user["name"],
                "email": user["email"],
            },
        })

    except Exception:
        app.logger.exception("Login failed")
        return jsonify({"error": "Unable to log in"}), 500


@app.route("/api/logout", methods=["POST"])
def logout():
    session.clear()
    return jsonify({"message": "Logged out successfully"})


@app.route("/api/me")
@login_required
def current_user():
    return jsonify({
        "id": session["user_id"],
        "name": session.get("user_name"),
        "email": session.get("user_email"),
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)