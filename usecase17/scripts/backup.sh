#!/bin/bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$PROJECT_DIR/storage/backups"
LOG_DIR="$PROJECT_DIR/storage/logs"

TIMESTAMP="$(date +'%Y%m%d_%H%M%S')_$$"
BACKUP_FILE="$BACKUP_DIR/claimsdb_$TIMESTAMP.dump"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

log "Starting PostgreSQL backup"

docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T postgres \
    pg_dump -U claimsuser -d claimsdb -Fc > "$BACKUP_FILE"

if [ ! -s "$BACKUP_FILE" ]; then
    log "ERROR: Backup file is empty"
    rm -f "$BACKUP_FILE"
    exit 1
fi

docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T postgres \
    pg_restore --list < "$BACKUP_FILE" > /dev/null

log "Backup validation successful"
log "Backup created: $BACKUP_FILE"

# Retain latest 7 backup files
ls -1t "$BACKUP_DIR"/claimsdb_*.dump 2>/dev/null |
    tail -n +8 |
    while IFS= read -r old_backup; do
        rm -f "$old_backup"
        log "Removed old backup: $old_backup"
    done

log "Backup process completed successfully"
