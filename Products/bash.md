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


# dd
## Securely wipe a drive
```
dd if=/dev/urandom of=/dev/sda status=progress
dd if=/dev/zero of=/dev/sda status=progress
dd if=/dev/urandom of=/dev/sda status=progress
```

## Bit-for-Bit Drive Copy to Compressed File
```
lsblk
dd bs=512 -flag=fullblock conv=noerror,sync if=/dev/sda of=/home/user/newimage.dd status=progress | gzip -c > /media/ubuntu/path/newimage_YYYY-MM-DD.img.gz.img.gz
```

## Bit-for-Bit Drive Copy Across Network from a Windows Box
Source (sending):
```
dd if=\\.\f: | nc 192.168.1.1 1234
```

Target (receiving):
```
nc -l -p 1234 | dd newimage.img
```

## Restore dd Backup to a Drive
```
gunzip -c image.img.gz | dd bs=512 iflag=fullblock of=/dev/sda status=progress
```

## Write a .iso Image to a Drive
```
lsblk
sudo dd bs=4M if=Downloads/thefile.iso of=/dev/sdd conv=fdatasync status=progress
```

## Create ISO Image of a Disc
First, find the device. Then, copy it.
```
mount
dd if=dev/sra0 of=thedisc.iso
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

