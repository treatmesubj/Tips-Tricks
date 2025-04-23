journalctl -f -u sshd
journalctl --since "1 hour ago" -u sshd
journalctl --since "yesterday" -u sshd
journalctl --since "2025-04-22 12:00:00" -u sshd

# system user-IDs
cat /etc/passwd | grep "/home/" | cut -d: -f1,3
# john:1000
journalctl _UID=1000
