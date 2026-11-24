# Rip With MakeMKV Beta
- https://www.makemkv.com/download/
- Ensure to set View > Preferences > Language > Preferred Language > eng: English



# Resize MKV  with ffmpeg to Pixel 9 Phone Resolution

## Extract from an ISO
(Typically with DVD)

Verify the title number:
```ps
$isoFile = "E:\temp\your_dvd_backup.iso"
$ffmpeg = "F:\GoogleDrive\Tony\Portable\Standalone\ffmpeg-2026-11-11-git-23c4540053-full_build\bin\ffmpeg.exe"

& $ffmpeg -f dvdvideo -title 1 -i $isoFile
```

Extract the title
```ps
$outFile = "E:\temp\dvd_pixel9.mkv"

& $ffmpeg -f dvdvideo -title 1 -analyzeduration 100M -probesize 100M -i $isoFile -map "0:v:0" -map "0:a:m:language:eng" -map "0:s:m:language:eng" -vf "bwdif=mode=0" -c:v libx265 -crf 20 -preset medium -c:a aac -b:a 192k -c:s copy $outFile
```


## Optimize the Output mkv with ffmpeg
(Typically with bluray)

https://www.gyan.dev/ffmpeg/builds/

First, copy libdvdcss-2.dll to the ffmpeg's \bin\ folder

1080p, filtering to only English audio tracks (this should include commentaries)
```ps
$inFile = "E:\temp\The Many Adventures Of Winnie The Pooh Special Edition_t00.mkv"
$outFile = "E:\temp\output.mkv"
$ffmpeg = "F:\GoogleDrive\Tony\Portable\Standalone\ffmpeg-2026-11-11-git-23c4540053-full_build\bin\ffmpeg.exe"

& $ffmpeg -analyzeduration 100M -probesize 100M -i $inFile -map "0:v:0" -map "0:a:m:language:eng" -map "0:s:m:language:eng" -c:v libx265 -crf 22 -preset medium -c:a aac -b:a 192k -c:s copy $outFile
```

4k UHD Source, downscaling to Pixel 9
```ps
$inFile = "E:\temp\your_4k_movie.mkv"
$outFile = "E:\temp\output_4k.mkv"
$ffmpeg = "F:\GoogleDrive\Tony\Portable\Standalone\ffmpeg-2026-11-11-git-23c4540053-full_build\bin\ffmpeg.exe"

& $ffmpeg -analyzeduration 100M -probesize 100M -i $inFile -map "0:v:0" -map "0:a:m:language:eng" -map "0:s:m:language:eng" -vf "scale=2424:-2" -c:v libx265 -pix_fmt yuv420p10le -crf 22 -preset medium -c:a aac -b:a 192k -c:s copy $outFile
```