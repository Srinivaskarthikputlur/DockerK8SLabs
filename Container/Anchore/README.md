# **Anchore**


### * *

-------

#### Step 1:

* Navigate to the `Anchore` directory on the provisioned server.

```commandline
cd /root/container-training/Container/Anchore/
```

-------

#### Step 2:

* Launch [`Anchore Engine`](https://github.com/anchore/anchore-engine) that can be accessed via. REST API

```commandline
docker-compose up -d

docker ps
```

### *Note: We will have an separate section on `docker-compose` soon!*

* Install [`anchorecli`](https://github.com/anchore/anchore-cli), the command line interface on top of the `Anchore Engine` REST API

```commandline
pip install anchorecli
```

* Set the necessary environment variables

```commandline
export ANCHORE_CLI_URL=http://localhost:8228/v1

export ANCHORE_CLI_USER=admin

export ANCHORE_CLI_PASS=foobar
```

-------

#### Step 3:

* Add an image to the Anchore Engine

```commandline
anchore-cli image add abhaybhargav/vul_flask:latest
```

* List the image analyzed by Anchore and fetch a specific image when once the status is `Analyzed`(This might take a while....)

```commandline
anchore-cli image list

anchore-cli image get docker.io/abhaybhargav/vul_flask:latest
```

* Perform a vulnerability scan on the image 

```commandline
anchore-cli image vuln docker.io/abhaybhargav/vul_flask:latest
```

* List out the `os` and `language` related issues present in the image and fetch the details

```commandline
anchore-cli image content docker.io/abhaybhargav/vul_flask:latest os

anchore-cli image content docker.io/abhaybhargav/vul_flask:latest python
```

### *Note: Try to perform a vulnerability scan on a distroless image and observe the results

-------

#### Step 4:

* Stop all containers

```commandline
docker-compose down

clean-docker
```

---------

### Reading Material/References:

* https://github.com/anchore/anchore-engine

* https://github.com/anchore/anchore-cli

* https://anchore.com/opensource/