from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
CORS(app)

DB_CONFIG = {
    "host": "localhost",
    "database": "claimsdb",
    "user": "claimsuser",
    "password": "claimspassword",
    "port": 5432
}


def get_db():
    return psycopg2.connect(**DB_CONFIG)


@app.route("/api/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "claims-backend"
    })


@app.route("/api/claims")
def get_claims():
    try:
        conn = get_db()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        cur.execute("""
            SELECT id, claim_number, customer_name, amount,
                   description, status, created_at
            FROM claims
            ORDER BY id DESC
        """)

        claims = cur.fetchall()

        cur.close()
        conn.close()

        return jsonify(claims)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/claims", methods=["POST"])
def create_claim():
    data = request.get_json()

    customer_name = data.get("customer_name")
    amount = data.get("amount")
    description = data.get("description")

    if not customer_name or not amount:
        return jsonify({
            "error": "Customer name and amount are required"
        }), 400

    try:
        conn = get_db()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        cur.execute("""
            INSERT INTO claims
            (customer_name, amount, description)
            VALUES (%s, %s, %s)
            RETURNING id, claim_number, customer_name,
                      amount, description, status, created_at
        """, (
            customer_name,
            amount,
            description
        ))

        claim = cur.fetchone()

        conn.commit()

        cur.close()
        conn.close()

        return jsonify(claim), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/claims/<int:claim_id>", methods=["PUT"])
def update_claim(claim_id):
    data = request.get_json()
    status = data.get("status")

    if status not in ["Pending", "Approved", "Rejected"]:
        return jsonify({
            "error": "Invalid status"
        }), 400

    try:
        conn = get_db()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        cur.execute("""
            UPDATE claims
            SET status = %s
            WHERE id = %s
            RETURNING id, claim_number, customer_name,
                      amount, description, status, created_at
        """, (status, claim_id))

        claim = cur.fetchone()

        if not claim:
            cur.close()
            conn.close()

            return jsonify({
                "error": "Claim not found"
            }), 404

        conn.commit()

        cur.close()
        conn.close()

        return jsonify(claim)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/register", methods=["POST"])
def register():
    data = request.get_json()

    name = data.get("name")
    email = data.get("email")
    password = data.get("password")

    if not name or not email or not password:
        return jsonify({
            "error": "All fields are required"
        }), 400

    try:
        conn = get_db()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        password_hash = generate_password_hash(password)

        cur.execute("""
            INSERT INTO users
            (name, email, password_hash)
            VALUES (%s, %s, %s)
            RETURNING id, name, email
        """, (
            name,
            email,
            password_hash
        ))

        user = cur.fetchone()

        conn.commit()

        cur.close()
        conn.close()

        return jsonify(user), 201

    except psycopg2.errors.UniqueViolation:
        conn.rollback()
        cur.close()
        conn.close()

        return jsonify({
            "error": "Email already registered"
        }), 409

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({
            "error": "Email and password are required"
        }), 400

    try:
        conn = get_db()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        cur.execute("""
            SELECT id, name, email, password_hash
            FROM users
            WHERE email = %s
        """, (email,))

        user = cur.fetchone()

        cur.close()
        conn.close()

        if not user:
            return jsonify({
                "error": "Invalid email or password"
            }), 401

        if not check_password_hash(user["password_hash"], password):
            return jsonify({
                "error": "Invalid email or password"
            }), 401

        return jsonify({
            "message": "Login successful",
            "user": {
                "id": user["id"],
                "name": user["name"],
                "email": user["email"]
            }
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)