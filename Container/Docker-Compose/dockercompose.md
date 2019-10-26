# Docker Compose

> Docker-compose is a tool used to run multi-container applications/services on a single host. The multi-container configuration setting can be done using a yaml file where requirements to deploy a service can be specified. Multiple container can be launched using a single command with help of the `docker-compose.yml` file.

### **Lab Image : Containers**

---

* Step 1: Navigate to the `Docker Compose` directory

```commandline
cd /root/container-training/Container/Docker-Compose/
```

* Step 2: Have a look at `docker-compose.yml` that's present in the directory

```commandline
cat docker-compose.yml
```

* Step 3: Update the `web server port`

```commanline
sed -i -e 's/80/8090/g' docker-compose.yml
```

* Step 4: Launch the containers using `docker-compose`

```commandline
docker-compose up -d
```

* Step 5: Open another browser tab, on the address bar, add `:8090` and press `Enter`.

## Teardown

* Step 6: Stop all the running containers

```commandline
docker-compose down
```

* Step 7: Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://docs.docker.com/compose/overview/
