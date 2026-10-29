import React, { useEffect, useState } from "react";
const API = "http://localhost:5000/api";

function App() {
    const [page, setPage] = useState("home");
    const [claims, setClaims] = useState([]);
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState("");

    const [claimForm, setClaimForm] = useState({
        customer_name: "",
        amount: "",
        description: ""
    });

    const [loginForm, setLoginForm] = useState({
        email: "",
        password: ""
    });

    const [registerForm, setRegisterForm] = useState({
        name: "",
        email: "",
        password: ""
    });

    useEffect(() => {
        if (page === "claims" || page === "home") {
            loadClaims();
        }
    }, [page]);

    async function loadClaims() {
        try {
            const response = await fetch(`${API}/claims`);
            const data = await response.json();

            if (response.ok) {
                setClaims(data);
            }
        } catch {
            setMessage("Unable to connect to backend");
        }
    }

    async function createClaim(e) {
        e.preventDefault();
        setLoading(true);
        setMessage("");

        try {
            const response = await fetch(`${API}/claims`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(claimForm)
            });

            const data = await response.json();

            if (!response.ok) {
                setMessage(data.error);
                return;
            }

            setMessage("Claim created successfully");

            setClaimForm({
                customer_name: "",
                amount: "",
                description: ""
            });

            await loadClaims();
            setPage("claims");

        } catch {
            setMessage("Unable to connect to backend");
        } finally {
            setLoading(false);
        }
    }

    async function updateStatus(id, status) {
        try {
            const response = await fetch(`${API}/claims/${id}`, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ status })
            });

            if (response.ok) {
                await loadClaims();
            }
        } catch {
            setMessage("Unable to update claim");
        }
    }

    async function login(e) {
        e.preventDefault();
        setMessage("");

        try {
            const response = await fetch(`${API}/login`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(loginForm)
            });

            const data = await response.json();

            if (!response.ok) {
                setMessage(data.error);
                return;
            }

            setMessage(`Welcome ${data.user.name}`);
            setPage("home");

        } catch {
            setMessage("Unable to connect to backend");
        }
    }

    async function register(e) {
        e.preventDefault();
        setMessage("");

        try {
            const response = await fetch(`${API}/register`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(registerForm)
            });

            const data = await response.json();

            if (!response.ok) {
                setMessage(data.error);
                return;
            }

            setMessage("Registration successful. Please login.");

            setRegisterForm({
                name: "",
                email: "",
                password: ""
            });

            setPage("login");

        } catch {
            setMessage("Unable to connect to backend");
        }
    }

    const total = claims.length;
    const pending = claims.filter(c => c.status === "Pending").length;
    const approved = claims.filter(c => c.status === "Approved").length;
    const rejected = claims.filter(c => c.status === "Rejected").length;

    return (
        <div className="app">
            <header>
                <div className="logo" onClick={() => setPage("home")}>
                    Claims<span>Management</span>
                </div>

                <nav>
                    <button onClick={() => setPage("home")}>Home</button>
                    <button onClick={() => setPage("claims")}>Claims</button>
                    <button onClick={() => setPage("create")}>Create Claim</button>
                    <button onClick={() => setPage("login")}>Login</button>
                </nav>
            </header>

            <main>

                {message && (
                    <div className="message">
                        {message}
                    </div>
                )}

                {page === "home" && (
                    <section>
                        <div className="hero">
                            <div>
                                <p className="small-title">CLAIMS PLATFORM</p>
                                <h1>Claims Management Application</h1>
                                <p>
                                    Manage customer claims, review their status
                                    and track claim activity from one place.
                                </p>

                                <button
                                    className="primary"
                                    onClick={() => setPage("claims")}
                                >
                                    View Claims
                                </button>
                            </div>
                        </div>

                        <div className="stats">
                            <div className="stat-card">
                                <h3>Total Claims</h3>
                                <strong>{total}</strong>
                            </div>

                            <div className="stat-card">
                                <h3>Pending</h3>
                                <strong>{pending}</strong>
                            </div>

                            <div className="stat-card">
                                <h3>Approved</h3>
                                <strong>{approved}</strong>
                            </div>

                            <div className="stat-card">
                                <h3>Rejected</h3>
                                <strong>{rejected}</strong>
                            </div>
                        </div>

                        <div className="section-title">
                            <h2>Recent Claims</h2>
                            <button onClick={() => setPage("create")}>
                                + Create Claim
                            </button>
                        </div>

                        <ClaimTable
                            claims={claims.slice(0, 5)}
                            updateStatus={updateStatus}
                        />
                    </section>
                )}

                {page === "claims" && (
                    <section>
                        <div className="page-title">
                            <p className="small-title">MANAGEMENT</p>
                            <h1>All Claims</h1>
                            <p>View and manage customer claims.</p>
                        </div>

                        <ClaimTable
                            claims={claims}
                            updateStatus={updateStatus}
                        />
                    </section>
                )}

                {page === "create" && (
                    <section className="form-page">
                        <div className="page-title">
                            <p className="small-title">NEW CLAIM</p>
                            <h1>Create Claim</h1>
                            <p>Enter the details of a new customer claim.</p>
                        </div>

                        <form className="form-card" onSubmit={createClaim}>
                            <label>Customer Name</label>
                            <input
                                type="text"
                                value={claimForm.customer_name}
                                onChange={e =>
                                    setClaimForm({
                                        ...claimForm,
                                        customer_name: e.target.value
                                    })
                                }
                                placeholder="Enter customer name"
                                required
                            />

                            <label>Claim Amount</label>
                            <input
                                type="number"
                                step="0.01"
                                value={claimForm.amount}
                                onChange={e =>
                                    setClaimForm({
                                        ...claimForm,
                                        amount: e.target.value
                                    })
                                }
                                placeholder="Enter claim amount"
                                required
                            />

                            <label>Description</label>
                            <textarea
                                value={claimForm.description}
                                onChange={e =>
                                    setClaimForm({
                                        ...claimForm,
                                        description: e.target.value
                                    })
                                }
                                placeholder="Describe the claim"
                            />

                            <button className="primary" type="submit">
                                {loading ? "Creating..." : "Submit Claim"}
                            </button>
                        </form>
                    </section>
                )}

                {page === "login" && (
                    <section className="auth-page">
                        <form className="auth-card" onSubmit={login}>
                            <p className="small-title">ACCOUNT</p>
                            <h1>Login</h1>

                            <label>Email</label>
                            <input
                                type="email"
                                value={loginForm.email}
                                onChange={e =>
                                    setLoginForm({
                                        ...loginForm,
                                        email: e.target.value
                                    })
                                }
                                required
                            />

                            <label>Password</label>
                            <input
                                type="password"
                                value={loginForm.password}
                                onChange={e =>
                                    setLoginForm({
                                        ...loginForm,
                                        password: e.target.value
                                    })
                                }
                                required
                            />

                            <button className="primary" type="submit">
                                Login
                            </button>

                            <p>
                                Don't have an account?
                                <button
                                    className="text-button"
                                    type="button"
                                    onClick={() => setPage("register")}
                                >
                                    Register
                                </button>
                            </p>
                        </form>
                    </section>
                )}

                {page === "register" && (
                    <section className="auth-page">
                        <form className="auth-card" onSubmit={register}>
                            <p className="small-title">ACCOUNT</p>
                            <h1>Create Account</h1>

                            <label>Name</label>
                            <input
                                type="text"
                                value={registerForm.name}
                                onChange={e =>
                                    setRegisterForm({
                                        ...registerForm,
                                        name: e.target.value
                                    })
                                }
                                required
                            />

                            <label>Email</label>
                            <input
                                type="email"
                                value={registerForm.email}
                                onChange={e =>
                                    setRegisterForm({
                                        ...registerForm,
                                        email: e.target.value
                                    })
                                }
                                required
                            />

                            <label>Password</label>
                            <input
                                type="password"
                                value={registerForm.password}
                                onChange={e =>
                                    setRegisterForm({
                                        ...registerForm,
                                        password: e.target.value
                                    })
                                }
                                required
                            />

                            <button className="primary" type="submit">
                                Register
                            </button>

                            <p>
                                Already have an account?
                                <button
                                    className="text-button"
                                    type="button"
                                    onClick={() => setPage("login")}
                                >
                                    Login
                                </button>
                            </p>
                        </form>
                    </section>
                )}

            </main>

            <footer>
                <p>Claims Management Application</p>
            </footer>
        </div>
    );
}


function ClaimTable({ claims, updateStatus }) {
    if (claims.length === 0) {
        return (
            <div className="empty">
                No claims available.
            </div>
        );
    }

    return (
        <div className="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Claim ID</th>
                        <th>Customer</th>
                        <th>Amount</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    {claims.map(claim => (
                        <tr key={claim.id}>
                            <td>{claim.claim_number}</td>
                            <td>{claim.customer_name}</td>
                            <td>${Number(claim.amount).toFixed(2)}</td>
                            <td>{claim.description || "-"}</td>
                            <td>
                                <span className={`status ${claim.status.toLowerCase()}`}>
                                    {claim.status}
                                </span>
                            </td>
                            <td>
                                <select
                                    value={claim.status}
                                    onChange={e =>
                                        updateStatus(
                                            claim.id,
                                            e.target.value
                                        )
                                    }
                                >
                                    <option>Pending</option>
                                    <option>Approved</option>
                                    <option>Rejected</option>
                                </select>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default App;