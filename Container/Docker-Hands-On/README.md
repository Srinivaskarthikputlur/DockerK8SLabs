# **Docker Hands-On**


### * *

-------

#### Step 1:

* Navigate to the `Docker Hands-on` directory on the provisioned server

```commandline
cd /root/container-training/Container/Docker-Hands-On/
```

-------

#### Step 2:

* Pull a docker image from DockerHub

```commandline
docker pull abhaybhargav/vul_flask
```

* List all docker images on the server

```commandline
docker images
```

* Run the `abhaybhargav/vul_flask` docker image.

```commandline
docker run -d --name vul_flask abhaybhargav/vul_flask
```

* View all running containers

```commandline
docker ps
```

* Check logs of a running container

```commandline
docker logs vul_flask
```

-------

#### Step 3:

* Exec into a running container

```commandline
docker exec -it vul_flask bash
```

* Exit from the container

```commandline
exit
```

* Stop the running `vul_flask` container

```commandline
docker stop vul_flask
```

* View all running and stopped containers

```commandline
docker ps -a
```

* Build and run a Docker image

```commandline
docker build -t helloworld:latest .
```
```commandline
docker run -d -p 5000:5000 helloworld:latest
```

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Access the `helloworld` application on the browser

```commandline
http://<IP>:5000
```

* Remove an image from the server

```commandline
docker rmi abhaybhargav/vul_flask
```

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:
