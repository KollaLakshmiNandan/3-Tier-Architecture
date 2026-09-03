CREATE DATABASE claimsdb;

CREATE USER claimsuser WITH PASSWORD 'claimspassword';

GRANT ALL PRIVILEGES ON DATABASE claimsdb TO claimsuser;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE claims (
    id SERIAL PRIMARY KEY,
    claim_number VARCHAR(20) UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE claim_number_seq START 1;

CREATE OR REPLACE FUNCTION generate_claim_number()
RETURNS TRIGGER AS $$
BEGIN
    NEW.claim_number :=
        'CLM-' || LPAD(nextval('claim_number_seq')::TEXT, 4, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER claim_number_trigger
BEFORE INSERT ON claims
FOR EACH ROW
WHEN (NEW.claim_number IS NULL)
EXECUTE FUNCTION generate_claim_number();

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO claimsuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO claimsuser;