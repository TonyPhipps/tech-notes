Kiwi Syslog Server

- When saving to file, defaults to syslog format RFC 5424. This may very well encapsulate the originally received syslog message.
  - the PRI and Version are truncated by default (e.g. no ```<34>1 ``` at the beginning.)

# Syslog File Regex
Kiwi Syslog server appears to export in syslog RFC 5424 format, but does not appear to export the fields PRI, Version, Application, PID, MessageID, or StructureData. It also uses tabs between the values it does export.
```
^(?<DateTime>.+?)\t(?<Priority>.+?)\t(?<Host>.+?)\t(?<Message>.+)
```