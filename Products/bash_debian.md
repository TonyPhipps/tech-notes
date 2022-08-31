For commands/tools specific to Debian-base

# Update System
```
apt update
apt list --upgradable
apt upgrade -y
```

# Enable Non-Free
```
apt-add-repository contrib
apt-add-repository non-free
```

# Install Legacy Nvidia Drivers
```
apt install nvidia-legacy-390xx-driver firmware-misc-nonfree
```
