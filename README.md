# User Creation and Permission Setup Script

A Bash script to automate the creation of Linux users, assign them to a group, set directory permissions, and enforce a secure password policy.

---

## Features

- Creates a new Linux user with a specified password.
- Adds the user to a group (creates the group if it doesn’t exist).
- Assigns group read and execute access (`r-x`) to a specified directory.
- Forces password change on first login.
- Prevents password changes for 30 days after setting.
- Requires password change every 30 days.
- Warns user 3 days before password expires.

---

## Requirements

- Must be run with `sudo` or as root.
- Target directory must exist prior to execution.

---

## Password Policy (via `chage`)

| Setting                              | Value     | Description                                                            |
|--------------------------------------|---------- |------------------------------------------------------------------------|
| Force password change at first login | Yes       | User must update password at first login                               |
| Minimum password age                 | 30 days   | User cannot change password again for 30 days after setting it         |
| Maximum password age                 | 30 days   | Password expires after 30 days and must be changed again               |
| Warning period before expiry         | 3 days    | User is warned 3 days before password expiration                       |

### Enforcement Summary

- On first login, the user is forced to change their temporary password.
- After that, the user **cannot change their password again for 30 days**.
- The password **expires automatically after 30 days**.
- The user is **warned 3 days before expiration** to change it in time.

---

## Directory Permissions

- The **group** is granted **read and execute** (`r-x`) access to the target directory.
- The **owner** (typically root or the creator) retains **full control** (`rwx`).
- **Others** have **no access**.

### Breakdown (`chmod 750`):

| User Type | Permission                     |
|-----------|--------------------------------|
| Owner     | Read, Write, Execute (`rwx`)   |
| Group     | Read, Execute (`r-x`)          |
| Others    | No access (`---`)              |

---

## File Name

`create_users.sh`

---

## What It Does

Given 4 inputs; **username, password, group name, and directory path,** the script:

1. Verifies that all required arguments are provided.
2. Checks if the specified group exists; creates it if not.
3. Checks if the user already exists; creates and configures them if not.
4. Validates that the specified directory exists.
5. Sets the group ownership and permissions of the directory to allow group access.
6. Enforces a strict password policy via `chage`.

---

## Usage

```bash
sudo ./create_users.sh <username> <password> <groupname> </path/to/folder>
```

---
## Example

```bash
sudo ./create_users.sh godson StrongPassword123 devs /var/www/project
```
---

## Sript Argument

1. USERNAME=$1          # First argument: the new username
2. PASSWORD=$2          # Second argument: the user's password
3. GROUP=$3             # Third argument: the group name
4. TARGET_DIR=$4        # Fourth argument: directory to apply group access

---

**Notes**
- Must be run with sudo/root privileges

- You can view the users in a group using:

```bash
getent group <groupname>
```

- You can test access as a user with:

```bash
sudo -u <username> ls /path/to/folder
```

## Author

**Godson Nwaubani**
Cloud & DevOps Engineer
[LinkedIn](https://www.linkedin.com/in/nwaubani-godson)

---

> “Security is not a feature — it’s a mindset.”
