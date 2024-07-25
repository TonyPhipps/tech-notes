# Setup
- Install Python
  - https://www.python.org/downloads/
- Download and extract Volatility
  - https://github.com/volatilityfoundation/volatility3/releases
- Open command prompt

```
cd C:\Users\you\Downloads\volatility3-2.7.0\
```

# Review image info
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.info
```

# vol.py -f .... example and quick ref
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.pslist
```
| Command         | Description                         |
| --------------- | ----------------------------------- |
| windows.pslist  | List running processes              |
| windows.pstree  | List running processes in tree form |
| windows.cmdline | List process command lines          |
| windows.netscan | List open network connections       |

# Dump a process by PID
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.pslist --dump --pid <PID>
```

# malfind
Finds processes deemed anomalous, like potential injection
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.malfind
```

# yara
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.vadyarascan --yara-files c:\path\to\sig.var
```



# Scan for strings
```
vol.py -f "C:\path\to\Triage-Memory.mem" windows.strings --strings-file "c:\path\to\strings.txt"
```
