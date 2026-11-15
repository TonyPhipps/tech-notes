# Rip with VLC
Rip to .ts, including all audio tracks
```
& "C:\Program Files\VideoLAN\VLC\vlc.exe" -I dummy dvdsimple:///H:\#0 --sout="#std{access=file,mux=mkv,dst=E:\clean_rip.mkv}" --sout-all vlc://quit
```

Rip to .ts, includes all English audio tracks and subtitles
```
& "C:\Program Files\VideoLAN\VLC\vlc.exe" -I dummy dvdsimple:///H:\#0 --sout="#std{access=file,mux=ts,dst=E:\clean_rip.ts}" --sout-all --sout-spu vlc://quit

& "C:\Program Files\VideoLAN\VLC\vlc.exe" -I dummy dvdsimple:///H:\#0 --sout="#std{access=file,mux=ts,dst=E:\clean_rip.ts}" --sout-all --sout-spu vlc://quit
```

# Convert to mkv with ffmpeg
https://www.gyan.dev/ffmpeg/builds/

First, copy libdvdcss-2.dll to the ffmpeg's \bin\ folder

Filters to only English audio tracks (this should include commentaries)
```
\ffmpeg.exe -fflags +genpts -i E:\clean_rip.ts -vf "yadif" -map 0:v:0 -map 0:a:m:language:eng -map 0:s -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy -c:s copy E:\output_original.mkv
```

Same as above, but scaled to 1080p
```
.\ffmpeg.exe -fflags +genpts -i E:\clean_rip.ts -vf "yadif,scale=-2:1080:flags=lanczos" -map 0:v:0 -map 0:a:m:language:eng -map 0:s -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy -c:s copy E:\output_1080p.mkv
```