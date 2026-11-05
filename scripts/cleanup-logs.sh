#!/bin/bash

set -euo pipefail

PROJECT_DIR="/var/www/laravel-app"
LOG_DIR="$PROJECT_DIR/storage/logs"

RETENTION_DAYS=14
MAX_SIZE_MB=500

CLEANUP_LOG="$LOG_DIR/cleanup.log"

mkdir -p "$LOG_DIR"

echo "[$(date '+%F %T')] Cleanup started" >> "$CLEANUP_LOG"

# Compress logs older than 24 hours, excluding today's log
find "$LOG_DIR" -maxdepth 1 -type f \
    -name 'laravel-*.log' \
    ! -name "laravel-$(date +%F).log" \
    -mmin +1440 \
    -exec gzip -- {} \;

# Delete compressed logs older than 14 days
find "$LOG_DIR" -maxdepth 1 -type f \
    -name 'laravel-*.log.gz' \
    -mmin +20160 \
    -delete

# Calculate folder size
SIZE_MB=$(du -sm "$LOG_DIR" | awk '{print $1}')

# Warn if folder exceeds 500 MB
if [ "$SIZE_MB" -gt "$MAX_SIZE_MB" ]; then
    echo "[$(date '+%F %T')] WARNING: Logs folder is ${SIZE_MB} MB (limit: ${MAX_SIZE_MB} MB)" >> "$CLEANUP_LOG"
else
    echo "[$(date '+%F %T')] Logs folder size: ${SIZE_MB} MB" >> "$CLEANUP_LOG"
fi

echo "[$(date '+%F %T')] Cleanup completed" >> "$CLEANUP_LOG"
