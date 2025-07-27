
#!/bin/bash

# Add to crontab
echo "Adding backup job to crontab..."
(crontab -l 2>/dev/null; echo "0 2 * * * /path/to/backup_script.sh -c /path/to/backup.conf") | crontab -

echo "Backup scheduled to run daily at 2 AM"
