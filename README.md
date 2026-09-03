# 3-Tier-Architecture

                    CLAIMS MANAGEMENT APPLICATION
                         3-TIER ARCHITECTURE

                              USER
                               │
                               │ HTTP
                               ▼
┌─────────────────────────────────────────────────────────┐
│                    TIER 1 — PRESENTATION                 │
│                                                         │
│                     React Frontend                      │
│                                                         │
│                  localhost:5173                         │
│                                                         │
│   ┌──────────┐ ┌──────────┐ ┌──────────────┐            │
│   │  Login   │ │  Claims  │ │ Create Claim │            │
│   └──────────┘ └──────────┘ └──────────────┘            │
│                                                         │
│                    App.jsx / CSS                        │
└─────────────────────────┬───────────────────────────────┘
                          │
                          │ REST API / JSON
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    TIER 2 — APPLICATION                 │
│                                                         │
│                     Flask / Python                      │
│                                                         │
│                  localhost:5000                         │
│                                                         │
│   ┌─────────────────────────────────────────────────┐   │
│   │                  REST APIs                       │   │
│   │                                                 │   │
│   │ GET  /api/health                                │   │
│   │ GET  /api/claims                                │   │
│   │ POST /api/claims                                │   │
│   │ PUT  /api/claims/<id>                           │   │
│   │ POST /api/register                              │   │
│   │ POST /api/login                                 │   │
│   └─────────────────────────────────────────────────┘   │
│                                                         │
│                       app.py                            │
└─────────────────────────┬───────────────────────────────┘
                          │
                          │ SQL
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                       TIER 3 — DATA                     │
│                                                         │
│                      PostgreSQL                         │
│                                                         │
│                       claimsdb                          │
│                                                         │
│   ┌────────────────────┐  ┌─────────────────────────┐   │
│   │       users        │  │        claims           │   │
│   │                    │  │                         │   │
│   │ id                 │  │ id                      │   │
│   │ name               │  │ claim_number            │   │
│   │ email              │  │ customer_name            │   │
│   │ password_hash      │  │ amount                  │   │
│   │ created_at         │  │ description             │   │
│   │                    │  │ status                  │   │
│   │                    │  │ created_at               │   │
│   └────────────────────┘  └─────────────────────────┘   │
│                                                         │
│              Automatic Claim Number Trigger             │
│                    CLM-0001, CLM-0002...                │
└─────────────────────────────────────────────────────────┘

Project structure :
--------------------
devopshub/
│
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   └── venv/
│
├── frontend/
│   ├── index.html
│   ├── package.json
│   └── src/
│       ├── App.jsx
│       ├── App.css
│       └── main.jsx
│
└── database/
    └── init.sql
