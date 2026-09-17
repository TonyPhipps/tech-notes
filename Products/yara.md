Scan all of C:\ with a given set of yara rules in a .yar file

```bat
yara64.exe -r my_rules.yar C:\
```

Create a master .yar file that points to all others
```ps
cd c:\path\to\rules\
Get-ChildItem -Filter *.yar -Exclude master.yar | ForEach-Object { 'include "{0}"' -f $_.FullName.Replace('\','/') } > master.yar
.\yara64.exe -r master.yar C:\
```