Use xxd to manually analyze binary files
```
xxd memdump.bin | less
```

Use strings to identify passwords
```
strings memdump.bin | less
```

Use entropy graphs to find asymmetric keys
```
binwalk -E hidden-key-raw
binwalk -B hidden-key-raw
binwalk -BE hidden-key-raw
```
