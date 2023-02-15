# Userchrome.css
#### Setup
- Open dynamic folder via about:support, then click on Profile Folder > Open Folder button
- Create a \chrome\ folder if needed.
- Create a chrome\userChrome.css file if needed

#### Enable
- about:config
- search for userprof
- Set toolkit.legacyUserProfileCustomizations.stylesheets to **true**

#### Various Preferences
Set Tab width to only show icons (great if using a vertical tab addon)
```
.tabbrowser-tab:not([pinned]) {
max-width: 30px !important;
min-width: 30px !important;
}
```

Hide tab (X) buttons
```
.tab-close-button {
	display:none!important; 
}
```
