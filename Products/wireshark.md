# Common Fields
- tcp.dstport
- tcp.port
- tcp.srcport
- ip.addr
- ip.src
- ip.dst
- udp.dstport
- udp.port
- udp.srcport


# Operators
- eq or ==
- ne or !=
- gt or >
- lt or <
- ge or >=
- le or <=

# Logic
- and or $$
- or or ||
- xor or ^^
- not or !

# Common Filter Examples
### In any frame, Find a non-case-sensitive string
```
frame matches "(?i)google"
```

# Fragmentation
(ip.flags.mf==1 or ip.frag_offset gt 0)

# Decode Text
- Select Packet
- Select ASCII text
- Analyze > Show Packet Bytes
- Change Start to the offset (offset = number of "dots" before the base64 string in the ASCII view)

# References and Resources
- https://packetlife.net/library/cheat-sheets/

# Columns
HTTP
| Title            | Type   | Field               |
| ---------------- | ------ | ------------------- |
| Source Port      | Custom | tcp.srcport         |
| Destination Port | Custom | tcp.dstport         |
| Request Method   | Custom | http.request.method |
| Response Code    | Custom | http.response.code  |
| URL              | Custom | http.host           |
| Path             | Custom | http.location       |
| Referrer         | Custom | http.referrer       |
| User Agent       | Custom | http.user_agent     |


SMB
| Title         | Type   | Field                    |
| ------------- | ------ | ------------------------ |
| TCP Delta     | Custom | tcp.time_delta           |
| Stream #      | Custom | tcp.stream               |
| Push          | Custom | tcp.flags.push           |
| TCP WinSize   | Custom | tcp.window_size          |
| Coloring Rule | Custom | frame.coloring_rule.name |
| SMB RspTime   | Custom | smb2.time                |
| SMB Read Len  | Custom | smb2.read_length         |
| SMB SessionID | Custom | smb2.sesid               |
| Tree          | Custom | smb2.tree                |
| Filename      | Custom | smb2.filename            |
| Message ID    | Custom | smb2.msg_id              |



# Review Rebuilt HTTP Stream
- Select Packet
- Analyze > Follow > HTTP Stream

# Export Objects
- Select Packet
- File > Export Objects > Select type

# File Magic Numbers
| Filetype             | Magic Number (Hex)                            | ASCII        |
| -------------------- | --------------------------------------------- | ------------ |
| executable/DOS       | 4D 5A -or- 4D 5A 00                           | .MZ -or- MZ  |
| Zip                  | 50 4B 03 04 -or- 50 4B 05 06 -or- 50 4B 07 08 | .PK          |
| PDF                  | 25 50 44 46 2d                                | %PDF         |
| GZIP                 | 1F 8B                                         | ..           |
| SWF                  | 43 57 53 -or- 46 57 53                        | FWD -or- CWS |
| Chrome Extension crx | 43 72 32 34                                   | Cr24         |

