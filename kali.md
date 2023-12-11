### Reset Linux Password
```
fdisk -l
mkdir /media/sda
mount /dev/sda3 /media/sda
chroot /media/sda
passwd
```