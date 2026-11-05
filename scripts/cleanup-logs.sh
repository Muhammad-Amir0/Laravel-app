
#!/bin/bash

set -euo pipefail

# Laravel project paths
PROJECT_DIR="/var/www/laravel-app"
LOG_DIR="$PROJECT_DIR/storage/logs"

# Cleanup settings
RETENTION_DAYS=14
MAX_SIZE_MB=500

# Separate cleanup log
CLEANUP_LOG="$LOG_DIR/cleanup.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Record cleanup activity
echo "[$(date '+%F %T')] Log cleanup started" >> "$CLEANUP_LOG"

# Compress log files older than one day.
# Today's log and already compressed files are excluded.
find "$LOG_DIR" -maxdepth 1 -type f \
    -name 'laravel-*.log' \
    -mtime +0 \
    -exec gzip -- {} \;

# Delete only compressed Laravel daily logs
# older than the retention period.
find "$LOG_DIR" -maxdepth 1 -type f \
    -name 'laravel-*.log.gz' \
    -mtime +"$RETENTION_DAYS" \
    -delete

# Calculate directory size in MB
SIZE_MB=$(du -sm "$LOG_DIR" | awk '{print $1}')

# Warn if the logs directory exceeds 500 MB
if [ "$SIZE_MB" -gt "$MAX_SIZE_MB" ]; then
    echo "[$(date '+%F %T')] WARNING: Logs folder is ${SIZE_MB} MB (limit: ${MAX_SIZE_MB} MB)" >> "$CLEANUP_LOG"
else
    echo "[$(date '+%F %T')] Logs folder size: ${SIZE_MB} MB" >> "$CLEANUP_LOG"
fi

echo "[$(date '+%F %T')] Log cleanup completed" >> "$CLEANUP_LOG"
