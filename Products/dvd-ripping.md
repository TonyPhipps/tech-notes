# Ripping via VLC
& "C:\Program Files\VideoLAN\VLC\vlc.exe" -I dummy dvdsimple:///H:\#0 --sout="#std{access=file,mux=mkv,dst=E:\clean_rip.mkv}" --sout-all vlc://quit



# Ripping va Handbrake
Did not work in my own testing.

Download:
- https://handbrake.fr/
- libdvdcss-2.dll


# Ripping via MPV
Did not work in my own testing.

Download:
- https://github.com/shinchiro/mpv-winbuild-cmake/releases
  - Download mpv-x86_64-v3-YYYYMMDD-git-xxxxxxx.7z from shinchiro’s mpv-winbuild-cmake GitHub releases (or install it directly via Windows Package Manager).

Decrypt The DVD
```
cd X:\Users\Tony\Downloads\mpv-x86_64-v3-20261111-git-bcde6b93cc
.\mpv dvd:// --dvd-device=H: --frames=0 -v | Select-String "title"
.\mpv dvd://1 --dvd-device=H: --ovc=copy --oac=copy --o=e:\decrypted.mkv
.\mpv dvd://0 --dvd-device=H: --stream-dump=e:\decrypted.vob
```


## ffmpeg convert
Convert it (Lossless)
```
ffmpeg -fflags +genpts -i e:\decrypted.vob -map 0:v -map 0:a -c copy output.mkv
```

Shrink into mp4
```
ffmpeg -fflags +genpts -i e:\decrypted.vob -vf yadif -c:v libx264 -crf 18 -preset slow -c:a copy output.mp4
```

Shrink into mp4 and 1080p resolution
```
ffmpeg -fflags +genpts -i decrypted.vob -vf "yadif,scale=-2:1080:flags=lanczos" -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a aac -b:a 192k output_1080p.mp4
```