# **Docker Compose**

---

> #### Docker-compose is a tool used to run multi-container applications/services on a single host. The multi-container configuration setting can be done using a yaml file where requirements to deploy a service can be specified. Multiple container can be launched using a single command with help of the `docker-compose.yml` file. (https://docs.docker.com/compose/overview/)

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `Docker Compose` directory on the provisioned server

```commandline
cd /root/container-training/Container/Docker-Compose/
```

---

#### Step 2:

* Have a look at `docker-compose.yml` that's present in the directory

```commandline
cat docker-compose.yml
```

* Have a look at the nginx configuration file

```commandline
cat conf.d/app.conf
```

> **NOTE**: Containers in docker-compose can communicate over the compose network using service name(s)

---

#### Step 3:

* Fetch the IP of the server provisioned

```commandline
serverip
```

* Build and launch the containers using docker-compose

```commandline
docker-compose up -d
```

* Once the containers are up and running, access the application on the browser using the IP of the provisioned server

```commandline
echo "http://$(serverip)"
```

---

#### Step 4:

* Stop all the running containers

```commandline
docker-compose down
```

---

#### *Teardown*:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

