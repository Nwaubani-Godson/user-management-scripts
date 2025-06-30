#!/bin/bash
set -euo pipefail

# Usage: sudo ./create_users.sh username password groupname /path/to/folder

USERNAME="$1"
PASSWORD="$2"
GROUP="$3"
TARGET_DIR="$4"

log() {
  echo "$(date +'%F %T') - $1"
}

# Validate arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: sudo $0 <username> <password> <groupname> </path/to/folder>"
  exit 1
fi

# Create group if it doesn't exist
if ! getent group "$GROUP" > /dev/null 2>&1; then
  log "Creating group: $GROUP"
  groupadd "$GROUP"
else
  log "Group '$GROUP' already exists."
fi

# Create user and set password
if id "$USERNAME" &>/dev/null; then
  log "User '$USERNAME' already exists."
else
  log "Creating user: $USERNAME"
  useradd -m -g "$GROUP" "$USERNAME"
  echo "$USERNAME:$PASSWORD" | chpasswd

  # Password Policy
  chage -d 0 "$USERNAME"                # Force change on first login
  chage -m 30 -M 30 -W 3 "$USERNAME"    # Lock for 30 days, expire after 30, warn 3 days before
  log "Password policy applied for '$USERNAME'"
fi

# Check directory existence
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist."
  exit 1
fi

# Set permissions
log "Setting group ownership of '$TARGET_DIR' to '$GROUP'"
chown -R ":$GROUP" "$TARGET_DIR"
chmod -R 750 "$TARGET_DIR"

# Final message
echo -e "\e[32m✔ User '$USERNAME' created and added to group '$GROUP'.\e[0m" # Green text for success
echo -e "\e[34mℹ Password policy: change on first login, 30-day reuse lock, 30-day expiry, 3-day warning.\e[0m" # Blue text for info
echo -e "\e[34mℹ Group access granted to '$TARGET_DIR' with read/execute permissions.\e[0m" # Blue text for info
