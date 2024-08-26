# Userchrome.css
#### Setup
- Open dynamic folder via about:support, then click on Profile Folder > Open Folder button
- Create a \chrome\ folder if needed.
- Create a chrome\userChrome.css file if needed
- about:config
- search for userprof
- Set toolkit.legacyUserProfileCustomizations.stylesheets to **true**

## Set Tab width to only show icons
Great if using a vertical tab addon.
```
.tabbrowser-tab:not([pinned]) {
max-width: 35px !important;
min-width: 35px !important;
}
```

Hide tab (X) buttons
```
.tab-close-button {
	display:none!important; 
}
```

## Set tabs to hide when Sideberry is open
```
/*
- Install Sideberry addon
- Sideberry Settings > Preface Value:
​
- Go to about:config
- Click Restart Normally...
*/

#main-window #titlebar {
  overflow: hidden;
  transition: height 0.3s 0.3s !important;
}
/* Default state: Set initial height to enable animation */
#main-window #titlebar { height: 3em !important; }
#main-window[uidensity="touch"] #titlebar { height: 3.35em !important; }
#main-window[uidensity="compact"] #titlebar { height: 2.7em !important; }
/* Hidden state: Hide native tabs strip */
#main-window[titlepreface*="​"] #titlebar { height: 0 !important; }
/* Hidden state: Fix z-index of active pinned tabs */
#main-window[titlepreface*="​"] #tabbrowser-tabs { z-index: 0 !important; }
```