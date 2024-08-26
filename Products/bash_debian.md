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

# Install OpenSSH Server
```apt install openssh-server```
- /etc/ssh/ssh_config (client config)
- /etc/ssh/sshd_config (server config)
- /etc/ssh contains the private/public key pairs identifying your host
- Use something like [WinSCP](https://winscp.net/eng/download.php) or [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/) to connect

## Regenerate keys
```
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
```

# Setup Firewall
Remove all traces of Iptables and flush all iptables rules

```# iptables -F && apt remove iptables iptables-persistent```

Nftables should be installed by default, but just in case...  
```# apt install nftables```

 We can see that there are no rules via
```# nft list ruleset```


# Create a Samba Fileshare
```
sudo apt update
sudo apt install samba
sudo useradd -m user1
sudo smbpasswd -a user1
mkdir /media/share1
chown user1 /media/share1
sudo nano /etc/samba/smb.conf
```

Add this stanza
```
[share1]
   path = /media/share1
   read only = no
   guest ok = no
   valid users = user1
```

Then restart Samba daemon
```
sudo systemctl restart smbd.service
```

If Enterprise GPO's are blocking you from accessing from a Windows host, o remove/comment out any map to guest line in your smb.conf, then restart Samba again.
