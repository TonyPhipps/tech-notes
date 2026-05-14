# Securely Wipe a Drive
```bash
dd if=/dev/urandom of=/dev/sda status=progress
dd if=/dev/zero of=/dev/sda status=progress
dd if=/dev/urandom of=/dev/sda status=progress
```


# Disk Backup and Restore

## Windows Drive Backup - No Compression, No Zero-Out, Just Sparse
Does not modify source drive or compress the backup file.

Backup
```bash
lsblk
sudo mkdir -p /mnt/windows
sudo mount /dev/sda2 /mnt/windows
sudo dd if=/dev/zero of=/mnt/windows/zero_bit bs=1M status=progress
sudo rm /mnt/windows/zero_bit
sync
sudo umount /mnt/windows
sudo dd if=/dev/sda of=/media/backup/windows_non_compressed.img bs=64K conv=sparse iflag=fullblock status=progress
sha256sum /media/backup/windows_non_compressed.img > /media/backup/windows_non_compressed.img.sha256
```

Restore
```bash
sha256sum -c windows_non_compressed.img.sha256
lsblk
sudo dd if=/media/backup/windows_non_compressed.img of=/dev/sda bs=64K conv=fsync status=progress
```

## Windows Drive Backup - Zero + Sparse + gzip Compression
NOTE: This zero's out empty space on the drive before backup.

Backup
```bash
lsblk
sudo mkdir -p /mnt/windows
sudo mount /dev/sda2 /mnt/windows
sudo dd if=/dev/zero of=/mnt/windows/zero_bit bs=1M status=progress
sudo rm /mnt/windows/zero_bit
sync
sudo umount /mnt/windows
sudo dd if=/dev/sda bs=64K conv=sparse iflag=fullblock status=progress | gzip -c > /media/backup/windows.img.gz
sha256sum /media/backup/windows.img.gz > /media/backup/windows.img.gz.sha256
```

Restore
```bash
sha256sum -c windows.img.gz.sha256
lsblk
gunzip -c /media/backup/windows.img.gz | sudo dd of=/dev/sda bs=64K conv=fsync status=progress
```


## Windows Drive Backup - Zero + Sparse
NOTE: This zero's out empty space on the drive before backup.

Backup
```bash
lsblk
sudo mkdir -p /mnt/windows
sudo mount /dev/sda2 /mnt/windows
cd /mnt/windows
sudo dd if=/dev/zero of=zero_bit bs=1M status=progress
sudo rm zero_bit
cd ~
sudo umount /mnt/windows
# Use the drive identifier (sda), not the partition identifier (sda2)
sudo dd if=/dev/sda of=/media/backup/windows_backup.img bs=64K conv=sparse iflag=fullblock status=progress
sha256sum /media/backup/windows_backup.img.gz > /media/backup/windows_backup.img.gz.sha256
```

Restore:
```bash
sha256sum -c windows_backup.img.gz.sha256
lsblk
sudo dd if=/media/backup/windows_backup.img of=/dev/sda bs=64K conv=fsync status=progress
```


## Windows Drive Backup - gzip Compression
```bash
lsblk
sudo dd if=/dev/sda bs=64K conv=sparse iflag=fullblock status=progress | gzip -c > /media/backup/windows_backup.img.gz
sha256sum /media/backup/windows_backup.img.gz > /media/backup/windows_backup.img.gz.sha256
```

Restore:
```bash
sha256sum -c windows_backup.img.gz.sha256
lsblk
gunzip -c /media/backup/windows_backup.img.gz | sudo dd of=/dev/sda bs=64K conv=fsync status=progress
```


## Windows Drive Backup  Across Network from a Linux Live CD
### Target (receiving)
Set this up first.

- -l: Listen
- -p: Port
- -q 1: Quit 1 sec after EOF

```bash
nc -l -p 1234 | gunzip -c | dd of=newimage.img bs=64K conv=fsync status=progress
```

After the run, verify the backup

Windows
```bat
certutil -hashfile \\.\PhysicalDrive1 SHA256
```

Linux
```bash
sha256sum newimage.img
```


### Source (sending)

- iflag=fullblock: Ensures integrity across the pipe
- gzip -1: Fast compression to speed up the network transfer

```bash
dd if=\\.\PhysicalDrive1 bs=64K conv=sparse iflag=fullblock status=progress | gzip -1 | nc 192.168.1.1 1234
```



