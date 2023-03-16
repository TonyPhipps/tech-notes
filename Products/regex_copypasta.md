Window Securit Event
```
(?<Channel>.+?)\t(?<EventRecordID>.+?)\t(?<TimeCreated>.+?)\t(?<EventID>.+?)\t(?<ProviderName>.+?)\t+(?<User>.+?)\t(?<Keywords>.+?)\t(?<Computer>.+?)\t(?<Field1>.+?)\t(?<EventName>[\w\s]+\.?)\s(?<EventXML>.+)
```

Windows Security Event UserData Field
<expand>
```
(Subject:(?<Subject>
    (\s+Security\sID:\s+(?<Subject_SecurityID>.+?)(?:\n|$))?
    (\s+Account\sName:\s+(?<Subject_AccountName>.+?)(?:\n|$))?
    (\s+Account\sDomain:\s+(?<Subject_AccountDomain>.+?)(?:\n|$))?
    (\s+Logon\sID:\s+(?<Subject_LogonID>.+?)(?:\n|$))?
    (\s+Logon\sType:\s+(?<Subject_LogonType>.+?)(?:\n|$))?
    )?
)?

(Creator\sSubject:(?<CreatorSubject>
    (\s+Security\sID:\s+(?<CreatorSubject_SecurityID>.+?)(?:\n|$))?
    (\s+Account\sName:\s+(?<CreatorSubject_AccountName>.+?)(?:\n|$))?
    (\s+Account\sDomain:\s+(?<CreatorSubject_AccountDomain>.+?)(?:\n|$))?
    (\s+Logon\sID:\s+(?<CreatorSubject_LogonID>.+?)(?:\n|$))?
    )?
)?

(Target\sSubject:(?<TargetSubject>
    (\s+Security\sID:\s+(?<TargetSubject_SecurityID>.+?)(?:\n|$))?
    (\s+Account\sName:\s+(?<TargetSubject_AccountName>.+?)(?:\n|$))?
    (\s+Account\sDomain:\s+(?<TargetSubject_AccountDomain>.+?)(?:\n|$))?
    (\s+Logon\sID:\s+(?<TargetSubject_LogonID>.+?)(?:\n|$))?
    )?
)?

(Object:(?<Object>
    (\s+Object\sServer:\s+(?<Object_ObjectServer>.+?)(?:\n|$))?
    (\s+Object\sType:\s+(?<Object_ObjectType>.+?)(?:\n|$))?
    (\s+Object\sName:\s+(?<Object_ObjectName>.+?)(?:\n|$))?
    (\s+Object\sHandle:\s+(?<Object_ObjectHandle>.+?)(?:\n|$))?
    (\s+Handle\sID:\s+(?<Object_HandleID>.+?)(?:\n|$))?
    (\s+Resource\sAttributes:\s(?<Object_ResourceAttributes>.+?)?(?:\n|$)?)?
    )?
)?

(Process\sInformation:(?<ProcessInfo>
    (\s+Process\sID:\s+(?<ProcessInfo_ProcessID>.+?)(?:\n|$))?
    (\s+Process\sName:\s+(?<ProcessInfo_ProcessName>.+?)(?:\n|$))?
    (\s+New\sProcess\sID:\s+(?<ProcessInfo_NewProcessID>.+?)(?:\n|$))?
    (\s+New\sProcess\sName:\s+(?<ProcessInfo_NewProcessName>.+?)(?:\n|$))?
    (\s+Token\sElevation\sType:\s+(?<ProcessInfo_TokenElevationType>.+?)(?:\n|$))?
    (\s+Creator\sProcess\sID:\s+(?<ProcessInfo_CreatorProcessID>.+?)(?:\n|$))?
    (\s+Process\sCommand\sLine:\s(?<ProcessInfo_ProcessCommandLine>.+?)(?:\n|$))?
    )?
)?

(Provider\sInformation:(?<ProviderInfo>
    (\s+ID:\s+(?<ProviderInfo_ID>.+?)(?:\n|$))?
    (\s+Name:\s+(?<ProviderInfo_Name>.+?)(?:\n|$))?
    )?
)?

(Change\sInformation:(?<ChangeInfo>
    (\s+Change\sType:\s+(?<ChangeInfo_ChangeType>.+?)(?:\n|$))?
    )?
)?

(Filter\sInformation:(?<FilterInfo>
    (\s+ID:\s+(?<FilterInfo_ID>.+?)(?:\n|$))?
    (\s+Name:\s+(?<FilterInfo_Name>.+?)(?:\n|$))?
    (\s+Type:\s+(?<FilterInfo_Type>.+?)(?:\n|$))?
    (\s+Run-Time\sID:\s+(?<FilterInfo_RuntimeID>.+?)(?:\n|$))?
    )?
)?

(Layer\sInformation:(?<LayerInfo>
    (\s+ID:\s+(?<LayerInfo_ID>.+?)(?:\n|$))?
    (\s+Name:\s+(?<LayerInfo_Name>.+?)(?:\n|$))?
    (\s+Run-Time\sID:\s+(?<LayerInfo_RuntimeID>.+?)(?:\n|$))?
    )?
)?

(Callout\sInformation:(?<CalloutInfo>
    (\s+ID:\s+(?<CalloutInfo_ID>.+?)(?:\n|$))?
    (\s+Name:\s+(?<CalloutInfo_Name>.+?)(?:\n|$))?
    )?
)?


(Requested\sOperation:(?<RequestedOperation>
    (\s+Desired\sAccess:\s+(?<RequestedOperation_DesiredAccess>.+?)(?:\n|$))?
    (\s+Privileges:\s+(?<RequestedOperation_Privileges>.+?)(?:\n|$))?
    )?
)?

(Operation:(?<Operation>
    (\s+Operation Type:\s+(?<Operation_OperationType>.+?)(?:\n|$))?
    (\s+Accesses:\s+(?<Operation_Accesses>.+?)(?:\n|$))?
    (\s+Access\sMask:\s+(?<Operation_AccessMask>.+?)(?:\n|$))?
    (\s+Properties:\s+(?<Operation_Properties>.+?)(?:\n|$))?
    )?
)?

(Additional\sInformation:(?<AdditionalInfo>
    (\s+Parameter\s1:\s+(?<AdditionalInfo_Param1>.+?)(?:\n|$))?
    (\s+Parameter\s2:\s+(?<AdditionalInfo_Param2>.+?)(?:\n|$))?
    (\s+Weight:\s+(?<AdditionalInfo_Weight>.+?)(?:\n|$))?
    (\s+Conditions:\s+(?<AdditionalInfo_Conditions>.+?)(?:\n|$))?
    (\s+Condition\sID:\s+(?<AdditionalInfo_ConditionID>.+?)(?:\n|$))?
    (\s+Match\sValue:\s+(?<AdditionalInfo_MatchValue>.+?)(?:\n|$))?
    (\s+Condition\sValue\s+(?<AdditionalInfo_ConditionValue>.+?)(?:\n|$))?
    (\s+Filter\sAction:\s+(?<AdditionalInfo_FilterAction>.+?)(?:\n|$))?
    )?
)?

(Service:(?<Service>
    (\s+Server:\s+(?<Service_Server>.+?)(?:\n|$))?
    (\s+Service\sName:\s+(?<Service_ServiceName>.+?)(?:\n|$))?
    )?
)?

(Process:(?<Process>
    (\s+Process\sID:\s+(?<Process_ProcessID>.+?)(?:\n|$))?
    (\s+Process\sName:\s+(?<Process_ProcessName>.+?)(?:\n|$))?
    )?
)?

(Service\sRequest\sInformation:(?<ServiceRequest>
    (\s+Privileges:\s+(?<ServiceRequest_Privileges>.+?)(?:\n|$))?
    )?
)?

(Permission\sChange:(?<PermChange>
    (\s+Original\sSecurity\sDescriptor:\s+(?<PermChange_OrigSecDescriptor>.+?)(?:\n|$))?
    (\s+New\sSecurity\sDescriptor:\s+(?<PermChange_NewSecDescriptor>.+?)(?:\n|$))?
    )?
)?

(Access\sRequest\sInformation:(?<AccessRequestInfo>
    (\s+Accesses:\s+(?<AccessRequestInfo_Accesses>.+?)(?:\n|$))?
    (\s+Access\sMask:\s+(?<AccessRequestInfo_AccessMask>.+?)(?:\n|$))?
    )?
)?

(Cryptographic\sParameters:(?<CryptoParams>
    (\s+Provider\sName:\s+(?<CryptoParams_ProviderName>.+?)(?:\n|$))?
    (\s+Algorithm\sName:\s+(?<CryptoParams_AlgorithmName>.+?)(?:\n|$))?
    (\s+Key Name:\s+(?<CryptoParams_KeyName>.+?)(?:\n|$))?
    (\s+Key Type:\s+(?<CryptoParams_KeyType>.+?)(?:\n|$))?
    )?
)?

(Cryptographic\sOperation:(?<CryptoOperation>
    (\s+Operation:\s+(?<CryptoOperation_Operation>.+?)(?:\n|$))?
    (\s+Return\sCode:\s+(?<CryptoOperation_ReturnCode>.+?)(?:\n|$))?
    )?
)?

(Key\sFile\sOperation\sInformation:(?<KeyFile>
    (\s+File\sPath:\s+(?<KeyFile_FilePath>.+?)(?:\n|$))?
    (\s+Operation:\s+(?<KeyFile_Operation>.+?)(?:\n|$))?
    (\s+Return\sCode:\s+(?<KeyFile_ReturnCode>.+?)(?:\n|$))?
    )?
)?
```
</expand>

Microsoft-Windows-WMI-Activity/Operation Event
```
(?<Channel>.+?)\t(?<EventRecordID>.+?)\t(?<TimeCreated>.+?)\t(?<EventID>.+?)\t(?<ProviderName>.+?)\t+(?<User>.+?)\t(?<Keywords>.+?)\t(?<Level>.+?)\t(?<Computer>.+?)\t(?<opCode>.+?)\s(?<UserData>.+)
```

Microsoft-Windows-WMI-Activity/Operation Event UserData Field
```
(Namespace\s=\s+(?<Namespace>.+?)(?:;|$)\s)?
(NotificationQuery\s=\s+(?<NotificationQuery>.+?)(?:;|$)\s)?
(Id\s=\s+(?<ID>.+?)(?:;|$)\s)?
(ClientMachine\s=\s+(?<ClientMachine>.+?)(?:;|$)\s)?
(User\s=\s+(?<User>.+?)(?:;|$)\s)?
(UserName\s=\s+(?<UserName>.+?)(?:;|$)\s)?
(ClientProcessId\s=\s+(?<ClientProcessID>.+?)(?:;|$)\s)?
(ClientMachine\s=\s+(?<Client_Machine>.+?)(?:;|$)\s)?
(Component\s=\s+(?<Component>.+?)(?:;|$)\s)?
(Operation\s=\s+(?<Operation>.+?)(?:;|$)\s)?
(ResultCode\s=\s+(?<ResultCode>.+?)(?:;|$)\s)?
(Consumer\s=\s+(?<Consumer>.+?)(?:;|$)\s)?
(PossibleCause\s=\s+(?<PossibleCause>.+?)(?:;|$)\s?)?
```

