# Solarwinds Event Log Fowarder Field Format
By default, forwards logs in syslog RFC 3164 format.
All Solarwinds Event Log Forwarder logs (that I've seen) contain the string "MSWinEventLog", which can be helfpul for matching via regex.

Fields
```
Priority, DateTime, Host, AppID, LogType, Criticality, Event
```

Regex
```
(?<timestamp>-|(?<month>\w+)\s(?<mday>[012]\d|3[01])\s(?<hour>[01]\d|2[0-4]):(?<minute>[0-5]\d):(?<second>[0-5]\d|60)?)\s(?<host>[^\s]+)\s(?<logtype>[^\s]+)\s(?<criticality>[0-9]+)\s(?<event>.*)
```

The same regex, but more descriptive/readable:
```
(?<timestamp>-|
    (?<month>\w+)\s
    (?<mday>[012]\d|3[01])\s
    (?<hour>[01]\d|2[0-4]):
    (?<minute>[0-5]\d):
    (?<second>[0-5]\d|60)(?#60seconds can be used for leap year!)?)\s
(?<host>[^\s]+)\s
(?<logtype>[^\s]+)\s
(?<criticality>[0-9]+)\s
(?<event>.*)
```

Security Event Fields
```
Provider, EventRecordID, DateLogged, EventID, Channel, Field1, Field2, SomeHost, SomeNumber, EventName
```


Sample
```
<10>May 03 09:39:06 vmwin2019demo.demo.ia MSWinEventLog	2	Security	5358377	Mon May 03 09:39:01 2021	4673	Microsoft-Windows-Security-Auditing	SNARE\demo	N/A	Failure Audit	vmwin2019demo.demo.ia	Sensitive Privilege Use		A privileged service was called.    Subject:   Security ID:  S-1-5-21-3312608775-1817375343-330975633-21763   Account Name:  demo   Account Domain:  SNARE   Logon ID:  0x33B83D    Service:   Server: Security   Service Name: -    Process:   Process ID: 0xe60   Process Name: C:\Program Files (x86)\Google\Chrome\Application\chrome.exe    Service Request Information:   Privileges:  SeProfileSingleProcessPrivilege	0
```