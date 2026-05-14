# Add user to sudoers
```
su -
usermod -aG sudo username
```

or add this to /etc/sudoers file
```
username ALL=(ALL: ALL) ALL
```

# crontab

### List crontab jobs for current user
```
crontab -l
```

### List crontab jobs for another user
```
crontab -l -u anotheruser
```

### List crontab jobs for all users
```
for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l; done
```

# base64
## Convert base64 to single-byte unicode
```
echo "SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABTAHkAcwB0AGUAbQAuAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACcAaAB0AHQAcAA6AC8ALwBzAHEAdQBpAHIAcgBlAGwAZABpAHIAZQBjAHQAbwByAHkALgBjAG8AbQAvAGEAJwApAAoA" | base64 -d | iconv -f UTF-16LE -t UTF-8
```




# Disable USB suspension
Some devices, like a wireless mouse USB dongle, may go into suspension mode and never return, requiring reinserting the dongle. This fixes that.
```
echo on | sudo tee /sys/bus/usb/devices/*/power/level >/dev/null
```

# Check for IP Routing
```
cat /proc/sys/net/ipv4/ip_forward
```

# Information and Logs
### IP address and NIC info
```
ip a show
ifconfig -a
```


### Linux Standard Base Release Information
```
lsb_release -a
```

### History
```
history
```
or 
```
cat ~/.bash_history
```

### Find Video Card Info
```
lspci -nn | egrep -i "3d|display|vga"
```

# General Baseline
## User Accounts
```
cat /etc/passwd
ls /home
```

## Installed Software
```
dkpg -l
rpm -qa
yum list included
dnf list installed
sudo debsums | grep -v OK
ls /opt
ls /usr/local/share
```

## System Settings
```
cat /etc/apt/sources.list
cat /etc/apt/sources.list.d/*
```

## Network Settings
```
ip link
ip -s link
ip address
ip neighbor
ip route
ss
ss -ltu
ss -ltunp
```

## Firewall
```
sudo iptables -L
```

## Full-Scanning Tool
```
sudo lynis audit system
```

# Misc
### Get IP address and send it through curl to an API
```
MSG=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//') && curl -s -F "token=xxx" -F "user=yyy" -F "message=$MSG" https://api.pushover.net/1/messages.json
```

### Set Primary Monitor
```
xrandr --listmonitors
xrandr --output DP-1-3 --primary
```

### Mount a Drive at Bootup
```
ls -al /dev/disk/by-uuid/
```
edit ```/etc/fstab```
Add an entry at the end of the file, something like
```
UUID=19fa40a3-fd17-412f-9063-a29ca0e75f93 /media/data   ext4    defaults,noatime        0       0
```
Verify fstab is not broken via
```
findmnt --verify
```

