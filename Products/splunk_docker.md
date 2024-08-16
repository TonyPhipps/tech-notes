# Setup Option 1
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

# Setup Option 2 - via docker-compose
Create a new directory.
Create folders:
- opt-splunk-etc
- opt-splunk-var-log
- var-log-splunk

Create a docker-compose.yml file next to the folders:

```
version: "3.6"

volumes:
  artifacts:
  resources:
  log:
  TA-REC:

services:
  splunk:
    image: ${SPLUNK_IMAGE:-splunk/splunk:latest}
    container_name: splunk
    hostname: splunk
    environment:
      - SPLUNK_PASSWORD=changeme
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_ENABLE_DEPLOY_SERVER="true"
      - SPLUNK_ENABLE_LISTEN=9997
      - SPLUNK_ADD="tcp 1514"
      - SPLUNK_LICENSE_URI=Free
      #- SPLUNK_APPS_URL=/mnt/resources/sankey-diagram-custom-visualization_130.tgz,/mnt/resources/config-explorer_1716.tgz
      #- SPLUNK_LICENSE_URI=/tmp/license/splunk.lic
      #- DEBUG=true
      #- SPLUNK_UPGRADE=true
    ports:
      - "1514:1514"
      - "8000:8000"
      - "8088:8088"
      - "8089:8089"
      - "9997:9997"

    volumes:
      - ./artifacts:/mnt/addons
      - ./resources:/mnt/resources
      - ./TA-REC:/opt/splunk/etc/apps/TA-REC
      - ./opt-splunk-var-log:/opt/splunk/var/log/splunk
```

Instead of "image: ###" you can refer to a dockerfile via
```
build:
  context: .
  dockerfile: ./Dockerfile
```

Run with:
```
sudo apt install docker-compose
set +o histexpand
cd /path/to/docker-compose.yml
SPLUNK_PASSWORD=<password> docker compose up -d
```

# Setup Option 3 - Splunk4DFIR via docker-compose
- Build a VM with at least 75GB Disk, 8GB Memory

- Install Docker
```
apt install docker
apt install docker.io
```

- Download and extract Splunk4DFIR
```
sudo apt install wget
wget https://github.com/mf1d3l/Splunk4DFIR/archive/refs/heads/main.zip
unzip main.zip
```

Past any artifacts you wish to ingest into subfolder of /path/to/splunk4DFIR-main/artifacts

- Change splunk4DFIR-main/artifacts permissions to allow ingestion
```
cd /path/to/splunk4DFIR-main
setfacl -Rdm o::rx artifacts
setfacl -Rm o::rx artifacts
```

Note: Add apps by downloading the .tgz, copying to ./resources, and adding the filename to SPLUNK_APPS_URL with a comma separator.
Note: If you comment out items in the middle of a section, Docker may skip. For example, commenting the ```./artifacts:/mnt/artifacts``` will cause Docker to also skip subsequent volumes in testing.

Create a directory to use as a log volume
```
mkdir opt-splunk-var-log
```

```
version: "3.6"

volumes:
  artifacts:
  resources:
  log:

services:
  splunk:
    build:
      context: .
      dockerfile: ./Dockerfile
    container_name: splunk4dfir
    hostname: splunk4dfir
    environment:
      - SPLUNK_PASSWORD=changeme
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_ENABLE_DEPLOY_SERVER="true"
      - SPLUNK_ENABLE_LISTEN=9997
      - SPLUNK_ADD="tcp 1514"
      - SPLUNK_LICENSE_URI=Free
      - SPLUNK_APPS_URL=/mnt/resources/sankey-diagram-custom-visualization_130.tgz,/mnt/resources/config-explorer_1716.tgz
      #- SPLUNK_LICENSE_URI=/tmp/license/splunk.lic
      #- DEBUG=true
      #- SPLUNK_UPGRADE=true
    ports:
      - "1514:1514"
      - "8000:8000"
      - "8088:8088"
      - "8089:8089"
      - "9997:9997"

    volumes:
      - ./artifacts:/mnt/artifacts
      - ./resources:/mnt/resources
      - ./opt-splunk-var-log:/opt/splunk/var/log/splunk

```

Navigate to 127.0.0.1:8000

The default credentials are admin:changeme

To cleanup/restart
```
sudo docker container stop splunk4dfir
sudo docker system prune
sudo docker volume prune
sudo docker compose up
```

After reboots
```
sudo bash
cd Splunk4DFIR-main
docker compose up
```



# Admin

To see a list of example commands and environment variables for running Splunk Enterprise in a container, run:

```docker run -it splunk/splunk help```

To see a list of your running containers, run:

```docker ps```

Display single container status
```docker ps -a -f id=<container_id>```

To stop your Splunk Enterprise container, run:

```docker container stop <container_id>```

To restart a stopped container, run:

```docker container start <container_id>```

To access a running Splunk Enterprise container to perform administrative tasks, such as modifying configuration files, run:

```docker exec -it <container_id> bash```

Access the Splunk instance with a browser by using the Docker machine IP address and Splunk Web port. For example, ``http://localhost:8000`


### Data Store
This Docker image has two data volumes:
- ```/opt/splunk/etc``` - stores Splunk configurations, including applications and lookups
- ```/opt/splunk/var``` - stores indexed data, logs and internal Splunk data

### Ports

This Docker container exposes the following network ports:

* `8000/tcp` - Splunk Web interface
* `8088/tcp` - HTTP Event Collector
* `8088/tcp` - Splunk Services
* `8191/tcp` - Application Key Value Store
* `9997/tcp` - Splunk receiving Port (not used by default) typically used by the Splunk Universal Forwarder
* `1514/tcp` - Network Input (not used by default) typically used to collect syslog TCP data

This Docker image uses port 1514 instead of the standard port 514 for the syslog port because network ports below 1024 require root access. See [Run Splunk Enterprise as a different or non-root user](http://docs.splunk.com/Documentation/Splunk/latest/Installation/RunSplunkasadifferentornon-rootuser).



Resources
- https://hub.docker.com/r/splunk/splunk
- https://splunk.github.io/docker-splunk/
- https://splunk.github.io/docker-splunk/EXAMPLES.html
- https://splunk.github.io/docker-splunk/advanced/APP_INSTALL.html
- https://splunk.github.io/docker-splunk/ADVANCED.html
- https://splunk.github.io/docker-splunk/STORAGE_OPTIONS.html
- https://docs.splunk.com/Documentation/Splunk/latest/Installation/DeployandrunSplunkEnterpriseinsideDockercontainers
- docs.splunk.com/Documentation/Splunk/latest/Installation/RunSplunkasadifferentornon-rootuser
- https://github.com/dennybritz/docker-splunk/tree/master/light
- 