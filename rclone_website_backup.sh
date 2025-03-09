#!/bin/bash
# Define the date variable
DATE=$(date +'%Y-%m-%d')

# List all website directories to back up (modify these paths as needed)
SITES=(
  "/www/site1"
  "/www/site2"
  "/www/site3"
  "/www/site4"
)

# Loop through each directory
for SITE_DIR in "${SITES[@]}"; do
    # Get the directory name to use in the backup file name
    SITE_NAME=$(basename "$SITE_DIR")
    # Define the backup file path
    BACKUP_FILE="/tmp/${SITE_NAME}_backup_${DATE}.tar.gz"
    # Compress the website directory.
    # The -C option changes to the parent directory so that the archive contains only the site folder.
    tar -czf "$BACKUP_FILE" -C "$(dirname "$SITE_DIR")" "$SITE_NAME"
    
    # Define the remote storage path.
    # Here we assume the rclone remote is named "dropbox" and the target directory is "backup".
    REMOTE="dropbox:backup/${SITE_NAME}_backup_${DATE}.tar.gz"
    
    # Use rclone to copy the backup file to the cloud storage
    rclone copy "$BACKUP_FILE" "$REMOTE" --verbose
    
    # Optionally, delete the local backup file after uploading
    rm -f "$BACKUP_FILE"
done
