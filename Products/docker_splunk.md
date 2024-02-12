# Setup
Pull
```
docker pull splunk/splunk:latest
```

Create a defaults.yml
```
docker run --rm -it splunk/splunk:latest create-defaults > default.yml
```

Run
```
docker run -d -p 8000:8000 -e SPLUNK_START_ARGS='--accept-license' -e SPLUNK_PASSWORD='<password>' splunk/splunk:latest
```

Display container status
```
docker ps -a -f id=<container_id>
```

Open Splunk
```
localhost:8000
```


# Admin

To see a list of example commands and environment variables for running Splunk Enterprise in a container, run:

```docker run -it splunk/splunk help```

To see a list of your running containers, run:

```docker ps```

To stop your Splunk Enterprise container, run:

```docker container stop <container_id>```

To restart a stopped container, run:

```docker container start <container_id>```

To access a running Splunk Enterprise container to perform administrative tasks, such as modifying configuration files, run:

```docker exec -it <container_id> bash```

