### My Go-to
- /MIR :: MIRror a directory tree (equivalent to /E plus /PURGE).
  - /E :: copy subdirectories, including Empty ones.
  - /PURGE :: delete dest files/dirs that no longer exist in source.

- /COPYALL :: COPY ALL file info (equivalent to /COPY:DATSOU).
  - /COPY:copyflag[s] :: what to COPY for files (default is /COPY:DAT).
    - (copyflags : D=Data, A=Attributes, T=Timestamps, S=Security=NTFS ACLs, O=Owner info, U=aUditing info).
- /ZB :: use restartable mode; if access denied use Backup mode.
- /TS :: include source file Time Stamps in the output.
- /ETA :: show Estimated Time of Arrival of copied files.
- /NP :: No Progress - don't display percentage copied.

```
robocopy "d:" "c:\d" /MIR /COPYALL /ZB /TS /ETA /NP
```

If it's preferred to not PURGE folders/files at destination, use /E rather than /MIR:
```
robocopy "c:\d" "d:" /E /COPYALL /ZB /TS /ETA /NP
```