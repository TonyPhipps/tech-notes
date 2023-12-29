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



# References and Resources
- https://packetlife.net/library/cheat-sheets/
