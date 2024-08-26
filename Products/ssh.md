# create an effective VPN tunnel through a bastion host using SSH

```
ssh -L 127.0.0.1:[ListeningPort]:[local ip]:[ReachoutPort] [BastionHostIP] -p [BastionHostPort] -N `
ssh -L 8888:192.168.100.120:3306 remote@2.2.2.2 -p 20022 -N
```
