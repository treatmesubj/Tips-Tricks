systemctl status --all
systemctl status postgresql

systemctl start postgresql
systemctl stop postgresql
systemctl restart postgresql
systemctl reload postgresql  # reload config files

systemctl enable postgresql  # start at boot
systemctl disable postgresql  # start at boot

