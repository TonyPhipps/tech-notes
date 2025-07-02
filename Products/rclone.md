- Setup for Google Drive
```
 rclone config
 No remotes found, make a new one?
    n
name> googledrive

Type of storage to configure.
Choose a number from below, or type in your own value

XX / Google Drive
   \ "drive"

Storage> drive

Google Application Client Id - leave blank normally.
client_id>

Google Application Client Secret - leave blank normally.
client_secret>

Scope that rclone should use when requesting access from drive.
Choose a number from below, or type in your own value
 1 / Full access all files, excluding Application Data Folder.
   \ "drive"
 2 / Read-only access to file metadata and file contents.
   \ "drive.readonly"
   / Access to files created by rclone only.
 3 | These are visible in the drive website.
   | File authorization is revoked when the user deauthorizes the app.
   \ "drive.file"
   / Allows read and write access to the Application Data folder.
 4 | This is not visible in the drive website.
   \ "drive.appfolder"
   / Allows read-only access to file metadata but
 5 | does not allow any access to read or download file content.
   \ "drive.metadata.readonly"
scope> 1

Service Account Credentials JSON file path - needed only if you want use SA instead of interactive login.
service_account_file>
Remote config

Use web browser to automatically authenticate rclone with remote?
 * Say Y if the machine running rclone has a web browser you can use
 * Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.
y) Yes
n) No
y/n> y

If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth
Log in and authorize rclone for access
Waiting for code...
Got code
Configure this as a Shared Drive (Team Drive)?
y) Yes
n) No
y/n> n

Configuration complete.
Options:
type: drive
- client_id:
- client_secret:
- scope: drive
- root_folder_id:
- service_account_file:
- token: {"access_token":"XXX","token_type":"Bearer","refresh_token":"XXX","expiry":"2014-03-16T13:57:58.955387075Z"}
Keep this "remote" remote?
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
```

List directories in top level of your drive
```
rclone lsd googledrive:
```

# rclone MOUNT
- Requires winfsp to be installed

```
rclone mount googledrive:TEST R:
```

Enable at startup


# rclone SYNC

- To SYNC a local directory to a Google Drive directory called test_Tony
  - This works better if you rename/move files, as --track-renames prevents re-uploading.
```
$params = @(
"sync",
"F:\GoogleDrive\Tony",
"googledrive:/Tony",
"--drive-skip-shortcuts",
"--drive-acknowledge-abuse",
"--drive-skip-gdocs",
"--drive-skip-dangling-shortcuts",
"--fast-list",
"--suffix-keep-extension",
"--track-renames",
#"--dry-run",
"--verbose"
)

X:\Users\Tony\Downloads\rclone-v1.70.2-windows-amd64\rclone.exe $params
```

Sync Local to Remote
Remove --dry-run after confirming it looks good
```
rclone sync SOURCE remote:DESTINATION --dry-run
```

# rclone BISYNC

- Sync Two Locations BOTH WAYS
  - First run with --resync --dry-run params to see outputs, but not change anything on your system so you can verify it works correctly.
  - Second run with --resync which triggers the initial redownload of the data from Google Drive
  - Third run without these params to check that the "normal operation" works.

  - Note this is not great for when files get renamed/moved around, as it will re-upload the whole file. Use SYNC for this use case.

```
$params = @(
"bisync",
"F:\GoogleDrive\Tony",
"googledrive:/Tony",
"--conflict-resolve", "newer",
"--conflict-loser", "delete",
"--conflict-suffix", "sync-conflict-{DateOnly}-",
"--compare", "size,modtime,checksum",
"--create-empty-src-dirs",
"--drive-skip-shortcuts",
"--drive-acknowledge-abuse",
"--drive-skip-gdocs",
"--drive-skip-dangling-shortcuts",
"--fast-list",
"--fix-case",
"--no-slow-hash",
"--suffix-keep-extension",
"--resilient",
"--recover",
"--resync",
"--dry-run",
"--verbose"
)

X:\Users\Tony\Downloads\rclone-v1.70.2-windows-amd64\rclone.exe $params
```

https://stacker.news/items/576670