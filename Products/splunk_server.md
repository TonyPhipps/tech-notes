# Install Splunk
```
dpkg -i splunk_package_name.deb
dpkg --status splunk
```

# Start
For the first time, best to run as root just to test things out.
```
su -
/opt/splunk/bin/splunk start
```

Don't forget to register for a Splunk Developer license and apply it
- https://dev.splunk.com/enterprise/dev_license/
- Settings > System > Licensing
- ```/opt/splunk/bin/splunk restart```

Accept EULA
provide username/password to configure splunk with

# Troubleshoot
Check who service is running as. Note that the service will NOT run properly without extra permissions beyond a simple "sudoers" group add.
```
ps -ef | grep splunk
```

