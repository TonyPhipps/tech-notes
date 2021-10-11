# Intro
Docker uses OS-level virtualization to deliver software in packages called containers. Sort of like a Virtual Machine (VM), except above the kernel layer. This simplifies things by letting the kernel deal with hardware. As a result, OS-level virtualization is much lighter than virtual machines.

## Image
An image is required to build a virtualized instance, and consists of a packaged file system, parameters, and commands. These can be hosted in a registry of containers, like [Docker Hub](https://hub.docker.com/).

## Container
A container is a virtualized instance of an image.


Good Reads
- https://www.tutorialspoint.com/docker/index.htm

# Commands

## Docker Image

### List Docker Images
```
docker image ls
```

Notable Parameters
- --all Shows all images
- --digests Adds column displaying digests

## Remove Image(s)
```
docker image rm ############
```

Where #'s represent one or more IMAGE ID's, separated by spaces. 

# Docker Container

## List Running Containers

```
docker container ls
```

Notable parameters
- --all Shows all containers
- --size Adds column displaying total file sizes

## Stop a Container

```
docker container stop ############
```

## Remove a Container

```
docker container rm ############
```