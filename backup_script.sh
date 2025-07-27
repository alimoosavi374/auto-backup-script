
#!/bin/bash

# Configuration variables
CONFIG_FILE="backup.conf"
LOG_FILE="backup.log"
BACKUP_PREFIX="backup_"
MAX_DAYS=7

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

# Function to display help
display_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -s, --source DIR       Specify source directory to backup"
    echo "  -d, --destination DIR  Specify backup destination directory"
    echo "  -f, --format EXT       Specify file extensions to backup (comma separated)"
    echo "  -n, --dry-run          Dry run (show what would be done)"
    echo "  -c, --config FILE      Specify config file (default: backup.conf)"
    echo "  -m, --max-days DAYS    Maximum age of backups to keep (default: 7)"
    echo "  -h, --help             Display this help message"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source)
            SOURCE_DIR="$2"
            shift
            shift
            ;;
        -d|--destination)
            DEST_DIR="$2"
            shift
            shift
            ;;
        -f|--format)
            FILE_FORMATS="$2"
            shift
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -c|--config)
            CONFIG_FILE="$2"
            shift
            shift
            ;;
        -m|--max-days)
            MAX_DAYS="$2"
            shift
            shift
            ;;
        -h|--help)
            display_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_help
            exit 1
            ;;
    esac
done

# Read config file if present
if [ -f "$CONFIG_FILE" ]; then
    log_message "Reading config file: $CONFIG_FILE"
    if [ -z "$SOURCE_DIR" ]; then
        SOURCE_DIR=$(grep -v '^#' "$CONFIG_FILE" | grep -i 'source=' | cut -d'=' -f2-)
    fi
    if [ -z "$DEST_DIR" ]; then
        DEST_DIR=$(grep -v '^#' "$CONFIG_FILE" | grep -i 'destination=' | cut -d'=' -f2-)
    fi
    if [ -z "$FILE_FORMATS" ]; then
        FILE_FORMATS=$(grep -v '^#' "$CONFIG_FILE" | grep -i 'formats=' | cut -d'=' -f2-)
    fi
fi

# Validate required parameters
if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "Error: Source and destination directories must be specified"
    display_help
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log_message "Error: Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    log_message "Creating destination directory: $DEST_DIR"
    if [ "$DRY_RUN" != true ]; then
        mkdir -p "$DEST_DIR"
    fi
fi

# Start backup
START_TIME=$(date +%s)
BACKUP_NAME="${BACKUP_PREFIX}$(date '+%Y%m%d_%H%M%S')"
BACKUP_PATH="$DEST_DIR/$BACKUP_NAME.tar.gz"

log_message "Starting backup process..."
log_message "Source: $SOURCE_DIR"
log_message "Destination: $BACKUP_PATH"
log_message "File formats: ${FILE_FORMATS:-all}"

# Find files
FIND_CMD="find \"$SOURCE_DIR\" -type f"
if [ -n "$FILE_FORMATS" ]; then
    IFS=',' read -ra FORMATS <<< "$FILE_FORMATS"
    FIND_CMD+=" \("
    for i in "${!FORMATS[@]}"; do
        if [ $i -gt 0 ]; then
            FIND_CMD+=" -o"
        fi
        FIND_CMD+=" -name \"*.${FORMATS[$i]}\""
    done
    FIND_CMD+=" \)"
fi
FIND_CMD+=" -print0"

if [ "$DRY_RUN" = true ]; then
    log_message "Dry run: would execute the following commands:"
    log_message "Find command: $FIND_CMD"
    log_message "Backup command: tar -czf \"$BACKUP_PATH\" --null -T <(xargs -0 <<< \"\$FILES\")"
    log_message "Cleanup command: find \"$DEST_DIR\" -name \"${BACKUP_PREFIX}*.tar.gz\" -mtime +$MAX_DAYS -delete"
    exit 0
fi

log_message "Searching for files..."
FILES=$(eval "$FIND_CMD")

if [ -z "$FILES" ]; then
    log_message "No files found matching the criteria"
    exit 0
fi

FILE_COUNT=$(echo "$FILES" | wc -l)
log_message "Found $FILE_COUNT files to backup"
log_message "Creating backup archive..."
eval "$FIND_CMD" | tar -czf "$BACKUP_PATH" --null -T -

if [ $? -eq 0 ] && [ -f "$BACKUP_PATH" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    log_message "Backup created successfully: $BACKUP_PATH ($BACKUP_SIZE)"
else
    log_message "Error: Backup creation failed"
    exit 1
fi

# Cleanup old backups
log_message "Cleaning up backups older than $MAX_DAYS days..."
find "$DEST_DIR" -name "${BACKUP_PREFIX}*.tar.gz" -mtime +$MAX_DAYS -delete

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
log_message "Backup completed in $DURATION seconds"

exit 0
