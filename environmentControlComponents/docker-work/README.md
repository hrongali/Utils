
### Basic commands
Check for running docker containers
```
docker ps
```
Build a docker image.(Have to be in the dir where Dockerfile is)
```
docker build -t example/docker-node-hello:latest .
```
Run the docker container and do port mapping
```
docker run -d -p 8080:8080 example/docker-node-hello:latest
```
Get into a docker container. Get the container name from `docker ps` command
```
docker exec -it f70ab4aac57a /bin/bash
```
Get the IP of the docker container
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' f70ab4aac57a
```
Stop the docker container
```
docker stop f70ab4aac57a
```
Inspect the docker container
```
docker inspect a4c4c46b3dc9
```
Login to Docker from console
```
docker login
```
Logout from docker from console
```
docker logout
```
Tag the local docker image with user name to be able to push to remote repository
```
docker tag example/docker-node-hello:latest hrongali/docker-node-hello:latest
```
Push the image to Docker hub repository
```
docker push hrongali/docker-node-hello:latest
```
Look for all docker images in the server
```
docker images
```
Pull the docker image
```
docker pull hrongali/docker-node-hello:latest
```
Remove the image from the docker host
```
docker rmi centos:latest
```
