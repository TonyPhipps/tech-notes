### Create Hard Link (Junction) Pointing to Directory in Command Prompt
```mklink /j "Link to create" "folder that holds data"```

Example with data in D: drive

```
mkdir "D:\Mozilla Firefox"
mklink /j "C:\Program Files\Mozilla Firefox" "D:\Mozilla Firefox"
```
