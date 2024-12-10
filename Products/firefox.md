# Hidden Features
- about:config
 
## Enable Sidebar
- sidebar.revamp [true]
- sidebar.verticalTabs [true]
- Set Sidebar to completely hide when you press the sidebar button
  - At bottom of sidebar, click Settings
  - Sidebar Button > select 'Show and Hide Sidebar'

## Enable Tab Grouping
- browser.tabs.groups.enabled

# userChrome Setup
- about:profiles
  - by "Root Directory" click Open Folder
  - Open (or create and open) directory 'chrome'
  - Open (or create and open) files 'userChrome.css'
- about:config
  - search for userprof
  - Set toolkit.legacyUserProfileCustomizations.stylesheets to **true**

# Hide Tabs
```
@media (-moz-bool-pref: "sidebar.verticalTabs"){
  #sidebar-main{
    visibility: collapse;
  }
}
@media (-moz-bool-pref: "userchrome.force-window-controls-on-left.enabled"){
  #nav-bar > .titlebar-buttonbox-container{
    order: -1 !important;
    > .titlebar-buttonbox{
      flex-direction: row-reverse;
    }
  }
}
@media not (-moz-bool-pref: "sidebar.verticalTabs"){
  #TabsToolbar{
    visibility: collapse;
  }
  :root[sizemode="fullscreen"] #nav-bar > .titlebar-buttonbox-container{
    display: flex !important;
  }
  :root:is([tabsintitlebar],[customtitlebar]) #toolbar-menubar:not([autohide="false"]) ~ #nav-bar{
    > .titlebar-buttonbox-container{
      display: flex !important;
    }
    :root[sizemode="normal"] & {
      > .titlebar-spacer{
        display: flex !important;
      }
    }
    :root[sizemode="maximized"] & {
      > .titlebar-spacer[type="post-tabs"]{
        display: flex !important;
      }
      @media (-moz-bool-pref: "userchrome.force-window-controls-on-left.enabled"),
        (-moz-gtk-csd-reversed-placement),
        (-moz-platform: macos){
        > .titlebar-spacer[type="post-tabs"]{
          display: none !important;
        }
        > .titlebar-spacer[type="pre-tabs"]{
          display: flex !important;
        }
      }
    }
  }
}
```