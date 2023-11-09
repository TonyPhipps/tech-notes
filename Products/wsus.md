# Setup
Open WSUS (Windows Server Update Services)
- Run through wizard and click "Start Connecting" ... may take a few minutes.
- Choose Languages
  - Keep just English (or add/change languages if needed)
- Choose Products
  - Keep defaults
    - Critical Updates
    - Definition Updates
    - Security Updates
    - Upgrades
- Configure Sync Schedule
  - Synchronize Automatically
    - Synchronizations Per Day: 1
- Finished
  - Check "Begin Initial Synchronization"

# Synchronization Reports
- To view synchronization reports, you will need to install somethings.
  - SQLSysClrTypes.msi can be found at https://www.microsoft.com/en-us/download/details.aspx?id=56041 ... this is required to install the Report Viewer. You only need install the single msi from the package.
  - A ReportViewer.msi link will be given when you attempt to view a report.
  - Once both are installed, close and reopen the WSUS window to view reports.