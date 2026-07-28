Run with smartcard credentials
```
\Windows\System32\runas.exe /smartcard /netonly /user:bor.doi.net\elevated-username "C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe"
```

# Transfer Files Using SSH Browser
In this example we are uploading a file, moving it to /tmp/ adjusting its permisisons, putting it in place, then adjusting permissions again.

- Upload files to /home/youruser
- As personal user:

`mv /home/aphipps/savedsearches.conf /tmp/`

- Adjust permissions to allow everyone to read it: 

`chmod 644 /tmp/savedsearches.conf`
- Change user to splunk: 

`dzdo su - splunk`

- Copy them to the necessary destination: 

 `cp /tmp/savedsearches.conf /opt/splunk/etc/apps/bor_ics_sigma/local/savedsearches.conf`

- Adjust permissions to restrict to splunk user:

`chmod 600 /opt/splunk/etc/apps/bor_ics_sigma/local/savedsearches.conf`

- Confirm:

`ll /opt/splunk/etc/apps/bor_ics_sigma/local`
