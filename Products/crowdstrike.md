# "Converting" Crowdstrike Custom IOA to Search
- Can't reference these Custom IOA fields in Crowdstrike's Search
  - Grandparent Image Filename
  - Grandparent Command Line
  - Parent Image Filename
  - Parent Command Line

- In the search below, replace ".*" with regex as needed.

```
CommandLine="*"
| rex Field=ImageFileName "(?<ImageFileNameMatch>.*)"
| rex Field=CommandLine "(?<CommandLineMatch>.*)"
| search CommandLineMatch=* ImageFileNameMatch=*
| fields ImageFileName, ImageFileNameMatch, CommandLine, CommandLineMatch
```
