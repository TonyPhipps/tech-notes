
# Remove a Scene
```ps
$InputFile = "C:\Path\To\File.mp4"
$CutStart  = "01:11:50"
$CutEnd    = "01:16:00"
$OutputFile = $InputFile -replace '(\.[^.]+)$', ' clipped$1'

ffmpeg -to $CutStart -i $InputFile -c copy part1.mp4
ffmpeg -ss $CutEnd -i $InputFile -c copy part2.mp4
"file 'part1.mp4'`nfile 'part2.mp4'" | Out-File -FilePath list.txt -Encoding ascii
ffmpeg -f concat -safe 0 -i list.txt -c copy $OutputFile
Remove-Item part1.mp4, part2.mp4, list.txt
```

# Fix audio that plays too early (Delay the Audio)
```ps
$InputFile = "C:\Path\To\File.mp4"
$OutputFile = $InputFile -replace '(\.[^.]+)$', ' synced$1'
$Offset = "0.5" # Adjust this to the number of seconds you need to shift
ffmpeg -i $InputFile -itsoffset $Offset -i $InputFile -map 0:v:0 -map 1:a:0 -c copy $OutputFile
```

# Fix audio that plays too late (Delay the Video)
```ps
$InputFile = "C:\Path\To\File.mp4"
$OutputFile = $InputFile -replace '(\.[^.]+)$', ' synced$1'
$Offset = "0.5" # Adjust this to the number of seconds you need to shift
ffmpeg -itsoffset $Offset -i $InputFile -i $InputFile -map 1:v:0 -map 0:a:0 -c copy $OutputFile
```
