Install Nessus Offline
- Generate an Activation Code
- Download installer (there is only an offline installer currently)
  - https://www.tenable.com/downloads/nessus?loginAttempted=true
  - Run and install with no special notes.
  - The browser should open after clicking Finish
  - Select Register Offline
  - Select Nessus Professional
  - Copy the unique Challenge Code
    - Example Challenge Code: `aaaaaa11b2222cc33d44e5f6666a777b8cc99999`
- Generate a license at https://plugins.nessus.org/v2/offline.php
  - The same page will continue to a page that provides a short-time use plugins download URL.
    - - https://plugins.nessus.org/v2/nessus.php?f=all-2.0.tar.gz&u=0e3b2a36c329c6846e6c6cc5c01f6437&p=65b226b83401f8aa2c300c14bd4fc1d5
  - Download the plugins.
  - https://docs.tenable.com/nessus/Content/UpdatePluginsOffline.htm
- Transfer Plugins file to the Nessus system.
  - NOTE: Transferring via VMWare commands works best if the file is split into 100MB chunks (7zip works great here)
  - Settings > About > Software Update > Manual Software Update (button top right)
    - or
  - C:\Program Files\Tenable\Nessus>nessuscli.exe update <tar.gz filename>
    - This command takes 10min to an hour to complete.
    - After the command completes, the system will "compile" all the plugins, as mentioned on the web server page when opened.
    - After the plugins are compiled, it may be another 10 minutes before completion.
    - A popup should appear, or the Scans > New Scan button should become available.


Scan Systems
- A Host Discovery Scan is needed first.
- After hosts are discovered, a Basic Network Scan can be conducted.
- After the Basic Network Scan is created (and optionally stopped), Configure the scan and go to Credentials
- Provide credentials as necessary.
- Don't forget to click Save at the far bottom edge of the page.
- Expect scans to take a few minutes per target endpoint.


Perform credentialed scans on non-domain joined endpoints
- https://docs.tenable.com/nessus/Content/CredentialedChecksOnWindows.htm#ConfigureWindows
  - Create accounts
  - Disable UAC
  - Set Firewall to allow file and printer sharing and other settings
  - Enable Remote Registry
  - Enable the default administrative shares (IPC$ and ADMIN$)

