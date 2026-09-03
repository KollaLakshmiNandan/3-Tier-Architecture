# 3-Tier Architecture

## Claims Management Application

A simple three-tier Claims Management Application built using React, Flask, and PostgreSQL.

## Architecture

```text
                    CLAIMS MANAGEMENT APPLICATION
                         3-TIER ARCHITECTURE

                              USER
                               │
                               │ HTTP
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    TIER 1 — PRESENTATION                    │
│                                                             │
│                       React Frontend                         │
│                                                             │
│                       localhost:5173                        │
│                                                             │
│       ┌──────────┐    ┌──────────┐    ┌──────────────┐     │
│       │  Login   │    │  Claims  │    │ Create Claim │     │
│       └──────────┘    └──────────┘    └──────────────┘     │
│                                                             │
│                       App.jsx / CSS                         │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               │ REST API / JSON
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    TIER 2 — APPLICATION                     │
│                                                             │
│                       Flask / Python                         │
│                                                             │
│                       localhost:5000                        │
│                                                             │
│                       REST APIs                              │
│                                                             │
│              GET    /api/health                              │
│              GET    /api/claims                              │
│              POST   /api/claims                              │
│              PUT    /api/claims/<id>                         │
│              POST   /api/register                            │
│              POST   /api/login                               │
│                                                             │
│                           app.py                             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               │ SQL
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                       TIER 3 — DATA                         │
│                                                             │
│                        PostgreSQL                            │
│                                                             │
│                         claimsdb                             │
│                                                             │
│       ┌──────────────────┐    ┌─────────────────────────┐   │
│       │      users       │    │         claims          │   │
│       ├──────────────────┤    ├─────────────────────────┤   │
│       │ id               │    │ id                      │   │
│       │ name             │    │ claim_number            │   │
│       │ email            │    │ customer_name            │   │
│       │ password_hash    │    │ amount                   │   │
│       │ created_at       │    │ description              │   │
│       └──────────────────┘    │ status                   │   │
│                               │ created_at               │   │
│                               └─────────────────────────┘   │
│                                                             │
│                 Automatic Claim Number Trigger              │
│                 CLM-0001, CLM-0002, ...                     │
└─────────────────────────────────────────────────────────────┘
```

## Project Structure

```text
devopshub/
│
├── backend/
│   ├── app.py
│   └── requirements.txt
│
├── frontend/
│   ├── index.html
│   ├── package.json
│   ├── package-lock.json
│   └── src/
│       ├── App.jsx
│       ├── App.css
│       └── main.jsx
│
├── database/
│   └── init.sql
│
├── .gitignore
└── README.md
```

## Technologies Used

- React
- Flask
- Python
- PostgreSQL
- REST API
- JSON
- psycopg2
- Vite
- Git
- GitHub

## Application Flow

```text
User
  │
  ▼
React Frontend
  │
  │ REST / JSON
  ▼
Flask Backend
  │
  │ SQL
  ▼
PostgreSQL
  │
  ▼
claimsdb
```

## Backend API Testing

### Health Check

```bash
curl http://localhost:5000/api/health
```

Expected response:

```json
{
  "service": "claims-backend",
  "status": "healthy"
}
```

### Get Claims

```bash
curl http://localhost:5000/api/claims
```

### Create Claim Using Backend CLI

```bash
curl -X POST http://localhost:5000/api/claims \
-H "Content-Type: application/json" \
-d '{"customer_name":"Demo User","amount":25000,"description":"Backend CLI test"}'
```

The Flask backend receives the request, executes the SQL `INSERT`, and stores the claim in PostgreSQL.

### Verify Data in PostgreSQL

```bash
psql -U claimsuser -d claimsdb
```

Then:

```sql
SELECT * FROM claims;
```

## Running the Application

### Start Backend

```bash
cd ~/devopshub/backend
source venv/bin/activate
python app.py
```

Backend:

```text
http://localhost:5000
```

### Start Frontend

Open another terminal:

```bash
cd ~/devopshub/frontend
npm run dev
```

Frontend:

```text
http://localhost:5173
```

## Current Status

- React frontend implemented
- Flask REST API implemented
- PostgreSQL database configured
- Claims CRUD functionality implemented
- User registration and login APIs implemented
- Automatic claim number generation implemented
- Backend tested using `curl`
- Database verified using PostgreSQL CLI
- Git repository initialized
- Project pushed to GitHub

## DevOps Roadmap

The application will be used as the reference application for the following DevOps workflow:

```text
Git
  ↓
GitHub
  ↓
CI/CD
  ↓
Tests
  ↓
SonarQube
  ↓
Trivy
  ↓
Docker
  ↓
Harbor
  ↓
Kubernetes
  ↓
Helm / Argo CD
  ↓
Vault
  ↓
Prometheus / Grafana
  ↓
Logs / Alerts
  ↓
SRE
  ↓
Incident / Recovery
  ↓
Platform Reuse
```
