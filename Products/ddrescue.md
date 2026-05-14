# Backup a hdd/sdd
```bash
# -S: Use sparse writes to skip zeros/empty space
# -n: First pass, skip bad sectors to get easy data quickly
# -v: Verbose output so you can see progress
sudo ddrescue -S -n -v /dev/sda /mnt/backup/disk_image.img /mnt/backup/rescue.map
sha256sum /mnt/backup/disk_image.img > /mnt/backup/disk_image.img.sha256
```


## Optional Scraping pass
If the drive is failing, run this second command to go back and try to recover the bad sectors skipped in the first pass:
```bash
# -r3: Retry bad sectors 3 times
# -d: Direct disc access (bypasses kernel cache for more accuracy on bad sectors)
sudo ddrescue -S -d -r3 /dev/sda /mnt/backup/disk_image.img /mnt/backup/rescue.map
```


# Restore from Backup
To restore the image back to a physical disk, you simply flip the input (if) and output (of).
```bash
# Restoring from the .img file back to a new physical drive (/dev/sdb)
# WARNING: Ensure /dev/sdb is the correct target!
sha256sum /mnt/backup/disk_image.img
sudo ddrescue -f /mnt/backup/disk_image.img /dev/sdb /mnt/backup/restore.map
```