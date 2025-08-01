https://splunkbase.splunk.com/app/742

```properties
# Stanzas Worth Adding/Customizing
[WinEventLog://Application]
disabled = 0
index = wineventlog
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml=false

[WinEventLog://Security]
disabled = 0
index = wineventlog
start_from = oldest
current_only = 0
evt_resolve_ad_obj = 1
checkpointInterval = 5
whitelist1 = 1100,1102,4609,4611,4616,4618,4624,4625,4634,4647,4648,4656,4657,4663,4664,4670,4672,4688,4689,4692,4693,4695,4696,4697,4698,4699,4700,4701,4702,4703,4704,4705,4715,4717,4718,4719,4720,4722,4723,4724,4725,4726,4731,4732,4733,4734,4735,4738,4739,4740,4767,4776,4778,4779,4780,4781,4782,4793,4798,4800,4801,4802,4803,4816,4817,4882,4885,4890,4898,4899,4906,4907,4908,4912,4946,4947,4948,4950,4951,4952,4953,4956,4957,4958,4964,5025,5027,5028,5029,5030,5031,5034,5035,5037,5038,5142,5143,5144,5146,5158,5376,5377,5378,5441,6145,6272,6273,6274,6275,6276,6277,6278,6279,6280,6281,6410,6416,6419,6420,6421,6422,6423,6424
whitelist2 = 4649,4706,4707,4713,4714,4716,4727,4728,4729,4730,4737,4741,4742,4743,4744,4745,4746,4747,4748,4749,4750,4751,4752,4753,4754,4755,4756,4757,4759,4760,4761,4762,4763,4764,4765,4766,4768,4769,4770,4771,4794,4799,4820,4865,4866,4867,5136,5137,5138,5139,5140,5141
blacklist1 = EventCode="4662" Message="Object Type:(?!\s*groupPolicyContainer)"
blacklist2 = EventCode="566" Message="Object Type:(?!\s*groupPolicyContainer)"
renderXml=false

[WinEventLog://System]
disabled = 0
index = wineventlog
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml=false

[WinEventLog://Microsoft-Windows-PowerShell/Operational]
disabled = 0
index = wineventlog
start_from = deepest
current_only = 0
evt_resolve_ad_obj = 1
checkpointInterval = 5
sourcetype = WinEventLog:Microsoft-Windows-PowerShell/Operational
whitelist1 = 4103,4104
renderXml = false

[WinEventLog://Microsoft-Windows-Windows Firewall With Advanced Security/Firewall]
disabled = 0
index = WinEventLog
start_from = deepest
current_only = 0
evt_resolve_ad_obj = 1
checkpointInterval = 5
sourcetype = WinEventLog:Microsoft-Windows-Windows Firewall With Advanced Security/Firewall
whitelist1 = 2002,2003,2004,2006,2008,2009,2032,2033,2052,2059,2060,2071,2082,2083,2097
renderXml = false


## Application and Services Logs - DFS Replication
[WinEventLog://DFS Replication]
index = wineventlog
disabled = 0
renderXml = false

## Application and Services Logs - File Replication Service
[WinEventLog://File Replication Service]
index = wineventlog
disabled = 0
renderXml = false

## WinEventLog Inputs for DNS
[WinEventLog://DNS Server]
index = wineventlog
disabled = 0
renderXml = false

## WinEventLog Inputs for Scheduled Tasks
[WinEventLog://Microsoft-Windows-TaskScheduler/Operational]
index = wineventlog
disabled = 0
renderXml = false

## WinEventLog Inputs for AppLocker
[WinEventLog://Microsoft-Windows-AppLocker/EXE and DLL]
disabled = 0
index = wineventlog

[WinEventLog://Microsoft-Windows-AppLocker/MSI and Script]
disabled = 0
index = wineventlog

[WinEventLog://Microsoft-Windows-AppLocker/Packaged app-Deployment]
disabled = 0
index = wineventlog

[WinEventLog://Microsoft-Windows-AppLocker/Packaged app-Execution]
disabled = 0
index = wineventlog

###### Windows Update Log ######
## WindowsUpdate.log for Windows 8, Windows 8.1, Server 2008R2, Server 2012 and Server 2012R2
[monitor://$WINDIR\WindowsUpdate.log]
index = wineventlog
disabled = 0
sourcetype = WindowsUpdateLog

###### Monitor Inputs for DNS ######
[MonitorNoHandle://C:\Windows\System32\Dns\dns.log]
sourcetype=MSAD:NT6:DNS
disabled=0
index=msad

### Host Monitor

[WinHostMon://Service]
interval = 43200
disabled = 0
type = Service
index=windows

[WinHostMon://Process]
interval = 1800
disabled = 0
type = Process
index=windows

[WinHostMon://Disk]
interval = 600
disabled = 0
type = Disk
index=windows

### Perfmon

## CPU
[perfmon://CPU]
counters = % Processor Time
disabled = 0
instances = *
interval = 60
mode = multikv
object = Processor
useEnglishOnly=true
index=perfmon

## Free Disk Space
[perfmon://LogicalDisk]
counters = Free Megabytes;% Free Space
disabled = 0
instances = *
interval = 3600
mode = multikv
object = LogicalDisk
useEnglishOnly=true
index=perfmon

## Memory
[perfmon://Memory]
counters = % Committed Bytes In Use
disabled = 0
instances = *
interval = 60
mode = multikv
object = Memory
useEnglishOnly=true
index=perfmon

## Physical Disk
[perfmon://PhysicalDisk]
counters = % Disk Time; Bytes/sec
disabled = 0
instances = *
interval = 60
mode = multikv
object = PhysicalDisk
useEnglishOnly=true
index=perfmon
```

# Splunk App for Windows fields seen in Sigma rules targeting ...

## Application
  - source="WinEventLog"
  - sourcetype="WinEventLog:Application"
  Channel="Application"
  - Provider_Name
  - EventCode
  - AppName
  - ExceptionCode
  - _raw

## System
  - AccountName
  - Binary
  - EventCode
  - HiveName
  - ImagePath
  - Param1
  - ProcessId
  - Provider_Name
  - ServiceName
  - source="WinEventLog"
  - sourcetype="WinEventLog:System"

## Security
  - AccessMask
  - Application
  - AttributeLDAPDisplayName
  - AttributeValue
  - AuditPolicyChanges
  - AuthenticationPackageName
  - Channel="Security"
  - ClientProcessId
  - IpAddress
  - IpPort
  - LogonProcessName
  - LogonType
  - NewTemplateContent
  - NewUacValue
  - ObjectClass
  - ObjectName
  - ObjectType
  - ObjectValueName
  - OldUacValue
  - param1
  - ParentProcessId
  - PrivilegeList
  - Process_Command_Line
  - ProcessName
  - Properties
  - RelativeTargetName
  - SamAccountName
  - ServiceFileName
  - ServiceName
  - ShareName
  - SidHistory
  - source="WinEventLog"
  - sourcetype="WinEventLog:Security"
  - Status
  - SubcategoryGuid
  - SubjectDomainName
  - SubjectUserName
  - SubjectUserSid
  - TargetOutboundUserName
  - TargetSid
  - TargetUserName
  - TargetUserSid
  - TaskContent
  - TaskContentNew
  - TemplateContent
  - Workstation
  - WorkstationName