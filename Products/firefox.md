# Enable Sidebar
- about:config
- sidebar.revamp [true]
- sidebar.verticalTabs [true]
- Set Sidebar to completely hide when you press the sidebar button
  - At bottom of sidebar, click Settings
  - Sidebar Button > select 'Show and Hide Sidebar'

# userChrome Setup
- about:profiles
  - by "Root Directory" click Open Folder
  - Open (or create and open) directory 'chrome'
  - Open (or create and open) files 'userChrome.css'
- about:config
  - search for userprof
  - Set toolkit.legacyUserProfileCustomizations.stylesheets to **true**
