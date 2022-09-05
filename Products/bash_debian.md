For commands/tools specific to Debian-base

# Update System
```
apt update
apt list --upgradable
apt upgrade -y
```

# Enable Contrib and Non-Free Repositories
```
apt-add-repository contrib
apt-add-repository non-free
apt update
```

# Install Legacy Nvidia Drivers
```
apt install nvidia-legacy-390xx-driver firmware-misc-nonfree
```

# Install Lutris
```
sudo dpkg --add-architecture i386

cd Downloads
wget -nc https://dl.winehq.org/wine-builds/winehq.key
apt-key add winehq.key

sudo touch /etc/apt/sources.list.d/wine.list
	deb https://dl.winehq.org/wine-builds/debian/ DEBVERSION main
sudo apt update
sudo apt install --install-recommends winehq-staging

cd Downloads
wget -q https://download.opensuse.org/repositories/home:/strycore/Debian_11/Release.key
apt-key add Release.key

sudo touch /etc/apt/sources.list.d/lutris.list
sudo gedit /etc/apt/sources.list.d/lutris.list
	deb http://download.opensuse.org/repositories/home:/strycore/Debian_11/ ./

apt-get update
apt-get install lutris
```
