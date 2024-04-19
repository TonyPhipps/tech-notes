# Change path to photos
cd path\to\photos\

# Check existing dates
e:\exiftool.exe -time:datetimeoriginal -G1 -a -s .\*.jpg

# Clear all EXIF data
e:\exiftool.exe -all= .\*.jpg -overwrite_original

# Apply a date to all date fields
e:\exiftool.exe -AllDates="2001-01-01 12:01:00" .\*.jpg -overwrite_original

# Increment date taken of all files to avoid collisions
e:\exiftool.exe '-AllDates+<0:00:00$FileSequence' .\*.jpg -fileorder filename -overwrite_original

# Rename all files to date taken
e:\exiftool.exe '-filename<CreateDate' -d %Y%m%d_%H%M%S%%-c.%%le -ext jpg -r .\ -overwrite_original
e:\exiftool.exe '-filename<DateTimeOriginal' -d %Y%m%d_%H%M%S%%-c.%%le -ext jpg -r .\ -overwrite_original

# Set Dates to filename
exiftool "-alldates<filename" .\*.jpg

# Preview a file's EXIF data
$pic="path\to\pic.jpg"
e:\exiftool.exe $pic
e:\exiftool.exe -time:all -G1 -a -s $pic

# Apply a date to all date fields
$pic="path\to\pic.jpg"
e:\exiftool.exe -AllDates="2001-01-01 12:01:00" $pic -overwrite_original