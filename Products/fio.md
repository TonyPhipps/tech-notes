# https://arstechnica.com/gadgets/2020/02/how-fast-are-your-disks-find-out-the-open-source-way-with-fio/
# https://fio.readthedocs.io/en/latest/
# https://bsdio.com/fio/

$testdir="d:\fiotest\"
mkdir $testdir -Force
cd $testdir


write-host "Single 4KiB random write process"
#fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1
fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1 | Select-Object -Last 1
 

write-host "16 parallel 64KiB random write processes"
#fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1
fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1 | Select-Object -Last 1


write-host "Single 1MiB random write process"
#fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1
fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1 | Select-Object -Last 1


cd ..
Remove-Item $testdir -Force -Recurse