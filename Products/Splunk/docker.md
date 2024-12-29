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

See for more:
- https://splunk.github.io/docker-splunk/
- https://splunk.github.io/docker-splunk/ADVANCED.html


# Setup Option 2 - Splunk4DFIR via docker-compose

NOTE: The steps below use Splunk4DFIR, but can be easily reused to produce a vanilla build:

Instead of the entire build: section, use 

```
image: ${SPLUNK_IMAGE:-splunk/splunk:latest}
```

-------------------------------------------------------

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


Create a docker-compose.yml file next to the folders:

```
volumes:
  artifacts:
    driver: local
    driver_opts:
      type: local
      o: bind
      device: ./artifacts
  resources:
    driver: local
    driver_opts:
        type: local
        o: bind
        device: ./resources
  var:
  etc:

services:
  splunk:
    build:
      context: .
      dockerfile: ./Dockerfile
    container_name: splunk4dfir
    hostname: splunk4dfir
    environment:
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_ENABLE_DEPLOY_SERVER="true"
      - SPLUNK_ENABLE_LISTEN=9997
      - SPLUNK_ADD=tcp 1514,udp 514
      - SPLUNK_LICENSE_URI=/tmp/license/Splunk.License
      - SPLUNK_APPS_URL=/mnt/resources/sankey-diagram-custom-visualization_130.tgz,/mnt/resources/config-explorer_1716.tgz
      #- SPLUNK_PASSWORD=changeme
      #- SPLUNK_LICENSE_URI=Free
      #- DEBUG=true
      #- SPLUNK_UPGRADE=true

    ports:
      - "514:514"
      - "1514:1514"
      - "8000:8000"
      - "8088:8088"
      - "8089:8089"
      - "9997:9997"

    volumes:
      - artifacts:/mnt/artifacts
      - resources:/mnt/resources
      - var:/opt/splunk/var
      - etc:/opt/splunk/etc
      - ./Splunk.License:/tmp/license/Splunk.License
      - ./default.yml:/tmp/defaults/default.yml
```

- Create a default.yml file, which will specify additional configurations for the Splunk Ansible setup process:
```
  splunk:
      conf:
        - key: ui-tour
          value:
            directory: /opt/splunk/etc/system/local
            content:
              default:
                useTour: false
              search-tour:
                viewed: 1
              dark-tour:
                viewed: 1
        - key: web
          value:
            directory: /opt/splunk/etc/system/local
            content:
              settings:
                updateCheckerBaseURL: 0
        - key: user-prefs
          value:
            directory: /opt/splunk/etc/system/local
            content:
              general:
                render_version_messages: 0
                hideInstrumentationOptInModal: 1
                dismissedInstrumentationOptInVersion: 4
              general_default:
                hideInstrumentationOptInModal: 1
                showWhatsNew: 0
        - key: telemetry
          value:
            directory: /opt/splunk/etc/apps/splunk_instrumentation/local
            content:
              general:
                precheckSendLicenseUsage: false
                precheckSendSupportUsage: false
                precheckSendAnonymizedUsage: false
                sendLicenseUsage: false
                sendSupportUsage: false
                sendAnonymizedUsage: false
                sendAnonymizedWebAnalytics: false
                optInVersionAcknowledged: 4
```

Run with:
```
sudo apt install docker-compose
set +o histexpand
cd /path/to/docker-compose.yml
SPLUNK_PASSWORD=<password> docker compose up -d
```

NOTE: If you encounter a Permission Denied error, it may be necessary to set the Splunk4DFIR-main permissions such that the user running the docker container can access the files:
```
cd path/to/Splunk4DFIR-main/parent
sudo setfacl -Rdm o::rx Splunk4DFIR-main
sudo setfacl -Rm o::rx Splunk4DFIR-main
```

Navigate to 127.0.0.1:8000

The default credentials are admin:changeme, if you didn't specify in the run command

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