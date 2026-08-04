# Intro
Docker uses OS-level virtualization to deliver software in packages called containers. Sort of like a Virtual Machine (VM), except above the kernel layer. This simplifies things by letting the kernel deal with hardware. As a result, OS-level virtualization is much lighter than virtual machines.

## Image
An image is required to build a virtualized instance, and consists of a packaged file system, parameters, and commands. These can be hosted in a registry of containers, like [Docker Hub](https://hub.docker.com/).

## Container
A container is an instantiated Image. Think of it as a process on the host OS.

Good Reads
- https://www.tutorialspoint.com/docker/index.htm

# Commands

| Command                           | Description                                                   |
| --------------------------------- | ------------------------------------------------------------- |
| docker version                    | get docker info                                               |
| docker pull ###                   | Download an image                                             |
| docker run ####                   | Pull, then run an image as a container                        |
| docker run -it ####               | Pull/run a container in interactive mode                      |
| docker image ls                   | list docker images                                            |
| docker image ls --all             | Shows all images                                              |
| docker image ls --digests         | Adds column displaying digests                                |
| docker image rm ####              | remove an image                                               |
| docker image rm #### ####         | remove two images                                             |
| docker image prune                | Removes all unused images                                     |
| docker container ls               | list running containers                                       |
| docker container ls --all         | list all containers                                           |
| docker container ls --size        | Adds column displaying total file sizes                       |
| docker container start ####       | start a container                                             |
| docker container stop ####        | stop a container                                              |
| docker container rm ####          | Remove a container                                            |
| docker container prune            | Removes all stopped containers                                |
| docker exec -it #### bash         | open a bash prompt in a container                             |
| docker run -v demo_volume:/data   | Run an image as a container with a volume mapped              |
| docker volume create demo_volume  | Create a volume apart from any image/container, for later use |
| docker volume ls                  | List volumes                                                  |
| docker volume inspect demo_volume | Inspect an existing volume                                    |
| docker volume rm demo_volume      | Remove an existing volume                                     |
| docker system prune               | removes unused containers, networks, images, cache            |
| docker volume prune               | Remove volumes not mounted to at least one container          |
| docker buildx prune -f            | remove the Docker build cache                                 |

# Docker Compose
Create one or more docker containers based on images


# Volumes in Depth
Defined as [sourceOnHost]:[destinationInContainer]

If you define [sourceOnHost] as a full path, it will store in that folder. If you define it as a name only, it will store by default on the docker server at ```/var/lib/docker/volumes```

```
docker run -d \
  --name devtest \
  -v myvol1:/app1 \
  -v myvol2:/app2 \
  nginx:latest
```

In docker-compose.yml file:
```
services:
  app:
    image: app-image:latest
    volumes:
      - app_data:/data
volumes:
  app_data:
    external: true  
```

Check a container's applied volumes
```
docker container ls
docker inspect containerid | jq .[].Mounts
```

List all volumes for a container
```
sudo docker volume ls
sudo docker volume inspect MyContainer_var --format='{{.Mountpoint}}'
```


# To Build an Image
- Internet connection is required to build the container image
1) Open a terminal, cd to `~/path/to/containername/`
2) Run `sudo docker compose build`
3) Run `sudo docker compose up` - once it completes, use `CTRL+Z` to send it to the background.
   - It is possible to just build the image without starting the container, but these steps assume you are testing the deployment as well.
   - If you do not want to see the logs, run `sudo docker compose up -d` instead to run the command in the background.
   - If you get a permission error during the Splunk setup steps, run
      ```bash
      cd ~/path/to/containername/../
      sudo setfacl -Rdm o::rx containername
      sudo setfacl -Rm o::rx containername
      ```
4) Connect to http://host-server-ip-address:8000 (HTTPS not enabled on the container)
   - This assumes the host is configured for NAT with port forwarding. If a bridged network is used, use the VM IP address.
5) Save the container image for use in an offline environment
   ```bash
   sudo docker save containername:latest | gzip > containername.tar.gz
   ```

  
# Load saved image for offline use  

Note: For the offline image to be used, the docker compose file must be in a folder named "containername". The image name of a compose container is the folder (containername) plus the service name (servicename).
```bash
sudo docker load --input containername-servicename.tar.gz
```
  