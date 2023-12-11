Get a USB stick ready for use as a bootup stick
```
DISKPART
LIST DISK - find the disk number of the usb drive
SELECT DISK # - # being your usb drive ( WARNING MAKE SURE YOU ARE SELECTING THE CORRECT DRIVE OTHERWISE THIS COULD BE DISASTROUS )
CLEAN
CREATE PARTITION PRIMARY
ACTIVE - Make the drive active
FORMAT FS=FAT32 - fat16/32 are the best option for syslinux
ASSIGN
EXIT
```