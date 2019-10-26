# Docker Hands-On

### **Lab Image : Containers**

---

* Step 1: Navigate to the `Docker Hands-on` directory

```commandline
cd /root/container-training/Container/Docker-Hands-On/
```

* Step 2 : Pull a docker image from DockerHub

```commandline
docker pull abhaybhargav/vul_flask
```

* Step 3: List all the docker images on the server

```commandline
docker images
```

* Step 4: Run the `abhaybhargav/vul_flask` docker image.

```commandline
docker run -d --name vul_flask abhaybhargav/vul_flask
```

* Step 5: View all the running containers

```commandline
docker ps
```

* Step 6: Check logs of a running container

```commandline
docker logs vul_flask
```

* Step 7: Exec into a running container

```commandline
docker exec -it vul_flask bash
```

* Step 8: View all the files inside the container

```commandline
ls
```

* Step 9: Exit from the container

```commandline
exit
```

* Step 10: Stop the running `vul_flask` container.

```commandline
docker stop vul_flask
```

* Step 11: View all running and stopped containers

```commandline
docker ps -a
```

* Step 12: Remove the stopped `vul_flask` container

```commandline
docker rm vul_flask
```

### Build a docker image

* Build and run a Docker image

* Docker file looks like this

```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install wget -y && wget -qO- https://get.docker.com | sh
RUN apt install -y ufw python-pip python-dev
RUN mkdir app
COPY helloworld /app/helloworld
ENV TESTENV="test"
WORKDIR /app/helloworld/
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["app.py"]
```

* Step 1: Navigate to the `Docker Hands-on` directory

```commandline
cd /root/container-training/Container/Docker-Hands-On/
```

* Step 2: Build a docker image using `docker build -t helloworld:latest .` command

```commandline
docker build -t helloworld:latest .
```

* Step 3: Run `helloworld:latest` docker image

```commandline
docker run -d -p 5000:5000 helloworld:latest
```

* Step 4: Open another tab and on the address bar, add `:5000` and press enter

## Teardown

* Step 5: Stop all containers

```commandline
clean-docker
```

### Reading Material/References:

* https://docs.docker.com/get-started/
