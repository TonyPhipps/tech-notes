# Intro
Docker uses OS-level virtualization to deliver software in packages called containers. Sort of like a Virtual Machine (VM), except above the kernel layer. This simplifies things by letting the kernel deal with hardware. As a result, OS-level virtualization is much lighter than virtual machines.

## Image
An image is required to build a virtualized instance, and consists of a packaged file system, parameters, and commands. These can be hosted in a registry of containers, like [Docker Hub](https://hub.docker.com/).

## Container
A container is an instantiated Image. Think of it as a process on the host OS.

Good Reads
- https://www.tutorialspoint.com/docker/index.htm

# Commands

| Command                                   | Description                              |
| ----------------------------------------- | ---------------------------------------- |
| docker version                            | get docker info                          |
| docker pull ###                           | Download an image                        |
| docker run ####                           | Pull, then run an image as a container   |
| docker run -it ####                       | Pull/run a container in interactive mode |
| docker image ls                           | list docker images                       |
| docker image ls --all                     | Shows all images                         |
| docker image ls --digests                 | Adds column displaying digests           |
| docker image rm ############              | remove an image                          |
| docker image rm ############ ############ | remove two images                        |
| docker container ls                       | list running containers                  |
| docker container ls --all                 | list all containers                      |
| docker container ls --size                | Adds column displaying total file sizes  |
| docker container stop ############        | stop a container                         |
| docker container rm ############          | Remove a container                       |
