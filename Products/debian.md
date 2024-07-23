# Minimum Specs
- Memory: 2 GB
- Disk: 10 GB

# Live Disk
- user: user
- pass: live

# Manual Partitioning
- /boot/efi 300, boot flag
- /swap/ 5120, swap flag
- /tmp/ 5120
- /var/ 5120
- / 102400 root
- /storage remaining space

# apt-get
Update the system
```
sudo apt-get update
```

Upgrade the OS
```
sudo apt-get update
sudo apt-get dist-upgrade
```

# install hyperv-daemons
```
apt-get install hyperv-daemons
```

reboot 
```
systemctl reboot
 ```

# Docker
Install
```
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Install Docker-Compose
```
sudo apt-get update
sudo apt-get install docker-compose-plugin
```

# Free up Space
```
sudo apt-get autoremove
sudo apt-get clean
sudo journalctl --vacuum-size=10M
sudo find /tmp -type f -exec du -h {} \; | sort -n
sudo logrotate /etc/logrotate.conf
sudo rm -rf /var/cache/*
sudo rm -rf /var/log/*
```