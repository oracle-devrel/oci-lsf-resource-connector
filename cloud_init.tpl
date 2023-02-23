#cloud-config

runcmd:
- /bin/firewall-offline-cmd --add-port=12345/tcp
- /bin/systemctl enable firewalld
- /bin/systemctl start firewalld