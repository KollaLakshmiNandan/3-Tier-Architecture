#!/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$PROJECT_DIR/storage/backups"

# Use supplied backup or select latest
BACKUP_FILE="${1:-$(find "$BACKUP_DIR" -name 'claimsdb_*.dump' -type f | sort | tail -n 1)}"

# Default to a separate recovery database
DB_NAME="${DB_NAME:-claimsdb_recovery}"

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "ERROR: Backup file not found!"
    exit 1
fi

echo "Starting database recovery..."
echo "Backup: $BACKUP_FILE"
echo "Target database: $DB_NAME"

docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T postgres \
    pg_restore --clean --if-exists --no-owner --no-privileges \
    -U claimsuser -d "$DB_NAME" < "$BACKUP_FILE"

echo "Database restoration completed successfully!"
