# Splunk UF Classic to XML
FIELDALIAS-RecordNumber = RecordNumber as EventRecordID
FIELDALIAS-EventCode = EventCode as EventID
FIELDALIAS-Severity = Severity as Level
FIELDALIAS-LogName = LogName as Channel
FIELDALIAS-ComputerName = ComputerName as Computer
FIELDALIAS-src_user = src_user as SubjectUserName
FIELDALIAS-Logon_ID = Logon_ID as TargetLogonID
FIELDALIAS-SessionID = SessionID as TargetLogonID
FIELDALIAS-user = user as TargetUserName
FIELDALIAS-dest_nt_domain = dest_nt_domain as TargetDomainName
FIELDALIAS-Logon_Type = Logon_Type as LogonType
FIELDALIAS-Creator_Process_Name = Creator_Process_Name as ParentProcessName
FIELDALIAS-Process_Command_Line = Process_Command_Line as CommandLine
FIELDALIAS-Sid = Sid as SubjectUserSid
FIELDALIAS-src_ip = src_ip as IpAddress
FIELDALIAS-event_id = event_id as EventRecordID
FIELDALIAS-id = id as EventRecordID
FIELDALIAS-Logon_Process = Logon_Process as LogonProcessName
FIELDALIAS-Authentication_Package = Authentication_Package as AuthenticationPackageName
FIELDALIAS-Source_Port = Source_Port as IpPort
FIELDALIAS-Logon_GUID = Logon_GUID as LogonGuid
FIELDALIAS-New_Process_Name = New_Process_Name as NewProcessName
FIELDALIAS-New_Process_ID = New_Process_ID as NewProcessID
FIELDALIAS-Workstation_Name = Workstation_Name as WorkstationName
# Aliases to allow partial mapping of Event 4688 Process creation events to Sysmon Event 1 
FIELDALIAS-ParentProcessName = ParentProcessName as ParentImage
FIELDALIAS-NewProcessName = NewProcessName as Image