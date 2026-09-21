Scan all of C:\ with a given set of yara rules in a .yar file

```bat
yara64.exe -r my_rules.yar C:\
```

Create a master .yar file that points to all others
```ps
$yarapath = "c:\path\to\yara\"
cd $yarapath
Get-ChildItem -Recurse -Filter *.yar | Where-Object { $_.Name -ne 'master.yar' } | ForEach-Object { 'include "{0}"' -f $_.FullName.Replace('\','/') } | Out-File -FilePath master.yar -Encoding ASCII
date
.\yara64.exe -r -p 10 'master.yar' C:\path\to\artifacts\
date
```