# BSD-syslog format (RFC 3164)
Structure
```
Priority Timestamp Host Application: Message
```

Examples:
```
<131>Jan 23 17:05:05 rdmlpavesi1d gs-rest-service error message slf4j thread:http-nio-8080-exec-1 priority:ERROR category:command.AppSyslogd.Application exception:
Feb 16 00:03:00 hostname MSWinEventLog 6 Microsoft-Windows-WMI-Activity/Operational 51531 Thu Feb 16 00:02:59 2018 5857 Microsoft-Windows-WMI-Activity S-1-5-20 N/A Information hostname 0 Win32_WIN32_TERMINALSERVICE_Prov provider started with result code 0x0. HostProcess = wmiprvse.exe; ProcessID = 503; ProviderPath = %SystemRoot%\system32\tscfgwmi.dll
<118> Apr 18 16:32:58 10.0.1.11 QAUDJRN: [AF@0 event="AF-Authority failure" violation="A-Not authorized to object" actual_type="AF-A" jrn_seq="1001363" timestamp="20120418163258988000" job_name="QPADEV000B" user_name="TESTFORAF" job_number="256937" err_user="TESTFORAF" ip_addr="10.0.1.23" port="55875" action="Undefined(x00)" val_job="QPADEV000B" val_user="TESTFORAF" val_jobno="256937" object="AFTEST" object_library="CUS9242" object_type="*FILE" pgm_name="" pgm_libr="" workstation=""]
<34>Oct 11 22:14:15 mymachine su: 'su root' failed for lonvick on /dev/pts/8
<34>Oct 11 22:14:15 mymachine su [9]: 'su root' failed for lonvick on /dev/pts/8
<34>Oct 11 22:14:15 mymachine su [9]:'su root' failed for lonvick on /dev/pts/8
```

#### Regular Expression
```
^(<(?<priority>[0-9]+)>)*\s*(?<timestamp>-|(?<month>\w+)\s(?<mday>[012]\d|3[01])\s(?<hour>[01]\d|2[0-4]):(?<minute>[0-5]\d):(?<second>[0-5]\d|60)?)\s(?<host>[^\s]+)\s(?<application>[^\s:\[]*)(?:\s\[*(?<pid>[0-9]+)\]*)?(?:[:\s]+)?(?<message>.*)$
```

Same expression, but extended for readability
```
^(<(?<priority>[0-9]+)>)*\s*
(?<timestamp>-|
    (?<month>\w+)\s
    (?<mday>[012]\d|3[01])\s
    (?<hour>[01]\d|2[0-4]):
    (?<minute>[0-5]\d):
    (?<second>[0-5]\d|60)(?#60seconds can be used for leap year!)?)\s
(?<host>[^\s]+)\s
(?<application>[^\s:\[]*)
(?:\s\[*(?<pid>[0-9]+)\]*)?
(?:[:\s]+)?
(?<message>.*)$
```


# IETF-syslog format (RFC 5424)

Top-level structure
```HEADER STRUCTURED-DATA MESSAGE```

#### HEADER
```Priority Version ISOTimestamp Host Application PID MessageID```

Notes: 
- Application, PID, and MessageID can be NULL, which SHOULD be represented by the dash character "-", but may just be missing. 

### STRUCUTRED DATA
The STRUCTURED-DATA message part may contain meta- information about the syslog message, or application-specific information such as traffic counters or IP addresses. STRUCTURED-DATA consists of data blocks enclosed in brackets ([]). Every block includes the ID of the block, and one or more name=value pairs.

Example:
```[exampleSDID@0 iut="3" eventSource="Application" eventID="1011"][examplePriority@0 class="high"]```

Notes: 
- Structured-Data can be NULL, which SHOULD be represented by the dash character "-", but may just be missing. 

#### MESSAGE
The MESSAGE part contains the text of the message itself. The character set used in MESSAGE SHOULD be UNICODE, encoded using UTF-8. If a syslog application encodes MESSAGE in UTF-8, the string MUST start with the Unicode byte order mask (BOM).

Examples:
```
<165>1 2003-08-24T05:14:15.000003-07:00 192.0.2.1 myproc 8710 - - %% It's time to make the do-nuts.
<34>1 2003-10-11T22:14:15.003Z mymachine.example.com su - ID47 - BOM'su root' failed for lonvick on /dev/pts/8
<190>1 2003-10-11T22:14:15.003Z mymachine.example.com evntslog - ID47 [exampleSDID@32473 iut="3" eventSource="Application" eventID="10\] 11"] BOMAn application event log entry..[ ] sadasd
<25>1 2003-10-11T22:14:15.003Z mymachine.example.com evntslog - ID47 [exampleSDID@32473 iut="3" eventSource="Application" eventID="1011"][examplePriority@32473 class="high"]
<1>12 - mymachine - - ID47 - asd asdaasd
1 2003-10-11T22:14:15.003Z mymachine myapplication 1234 ID47 [example@0 class="high"] BOMmyapplication is started
```

Notes: 
- Message can be entirely empty.

#### Regular Expression
```
^(<(?<priority>\d|\d{2}|1[1-8]\d|19[01])>)*(?<version>\d{1,2})\s(?<timestamp>-|(?<fullyear>[12]\d{3})-(?<month>0\d|[1][012])-(?<mday>[012]\d|3[01])T(?<hour>[01]\d|2[0-4]):(?<minute>[0-5]\d):(?<second>[0-5]\d|60)(?:\.(?<secfrac>\d{1,6}))?(?<numoffset>Z|[+-]\d{2}:\d{2}))\s(?<hostname>[\S]{1,255})\s(?<appname>[\S]{1,48})\s(?<procid>[\S]{1,128})\s(?<msgid>[\S]{1,32})\s(?<structureddata>-|(?:\[.+?(?<!\\)\])+)(?:\s(?<msg>.+))?$
```

The same, but extended for readability:
```
(?#regexp & naming based on RFC5424)
^(<(?<priority>\d|\d{2}|1[1-8]\d|19[01])>)*
(?<version>\d{1,2})\s
(?<timestamp>-|
    (?<fullyear>[12]\d{3})-
    (?<month>0\d|[1][012])-
    (?<mday>[012]\d|3[01])T
    (?<hour>[01]\d|2[0-4]):
    (?<minute>[0-5]\d):
    (?<second>[0-5]\d|60)(?#60seconds can be used for leap year!)
    (?:\.(?<secfrac>\d{1,6}))?
    (?<numoffset>Z|[+-]\d{2}:\d{2})(?#=timezone))\s
(?<hostname>[\S]{1,255})\s
(?<appname>[\S]{1,48})\s
(?<procid>[\S]{1,128})\s
(?<msgid>[\S]{1,32})\s
(?<structureddata>-|(?:\[.+?(?<!\\)\])+)
(?:\s(?<msg>.+))?$
```

Notes: 
- Any changes from the fully, complete standard may require modifying the above regex samples. Odds are, whatever you are working with is not a 100% match to the RFC... hopefully it's at least consistent with itself :)