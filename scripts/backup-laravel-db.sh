#!/bin/bash
set -Eeuo pipefail
umask 077

BACKUP_DIR="/var/www/laravel-app/storage/app/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR"

TMP_FILE="$BACKUP_DIR/.laravel_app_${TIMESTAMP}.tmp"
FINAL_FILE="$BACKUP_DIR/laravel_app_${TIMESTAMP}.sql.gz"

trap 'rm -f "$TMP_FILE"' EXIT

mysqldump \
  --defaults-extra-file=/home/ubuntu/.my.cnf \
  --single-transaction \
  --quick \
  --routines \
  --triggers \
  --events \
  --no-tablespaces \
  laravel_app | gzip > "$TMP_FILE"

gzip -t "$TMP_FILE"

mv "$TMP_FILE" "$FINAL_FILE"

find "$BACKUP_DIR" -type f -name 'laravel_app_*.sql.gz' -mmin +10080 -delete

echo "Backup completed: $FINAL_FILE"
