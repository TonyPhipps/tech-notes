### URLs
WF-600 Console - https://xxx.xxx.xxx.xxx:9000
WF-600 Console config - https://xxx.xxx.xxx.xxx:9000/console
WF-600 Config - https://xxx.xxx.xxx.xxx/Wf/Ds/Tx

### Default Administrator/user Password
qwER12#

### Streams
Between the TX and RX, the Connector ID's must match between streams, links, etc

### Access Screen cap
https://xxx.xxx.xxx.xxx:8007/video.cgi


### Grant Rights to Restart Services Without Admin
```
Get-Service | Where {$_.DisplayName -like "Waterfall*"} | Add-AccessControlEntry -ServiceAccessRights Start,Stop -Principal [Group Name] 
```
Note: Add-AccessControlEntry is not a built in commandlet but it can be obtained here: https://github.com/rohnedwards/PowerShellAccessControl