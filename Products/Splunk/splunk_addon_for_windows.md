https://splunkbase.splunk.com/app/742

Splunk App for Windows fields seen in Sigma rules targeting ...

### Application
  - source="WinEventLog"
  - sourcetype="WinEventLog:Application"
  Channel="Application"
  - Provider_Name
  - EventCode
  - AppName
  - ExceptionCode
  - _raw

### System
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

### Security
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