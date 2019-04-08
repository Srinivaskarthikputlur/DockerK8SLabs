# **Clair**


### *Vulnerability Static Analysis for Containers*

-------

#### Step 1:

* Navigate to the `Clair` directory on the provisioned server.

```commandline
cd /root/container-training/Container/Clair/
```

-------

#### Step 2:

* Launch [`arminc/clair-db`](https://cloud.docker.com/repository/docker/arminc/clair-db), the pre-filled Database

```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:2019-01-01
```

* Wait for a few seconds for the database to initialize. Check the container logs to confirm

```commandline
docker logs db
```

* Launch [`arminc/clair-local-scan`](https://cloud.docker.com/repository/docker/arminc/clair-local-scan), the Clair local scanner.

```commandline
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

-------

#### Step 3:

* Pull the image to be scanned

```commandline
docker pull abhaybhargav/vul_flask:latest
```

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Run Clair scan against the image and generate a `json` report

```commandline
./clair-scanner --ip <IP> -r clair_report.json abhaybhargav/vul_flask:latest
```

**EXAMPLE**: `./clair-scanner --ip 104.1.1.1 -r clair_report.json abhaybhargav/vul_flask:latest`

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:

* https://github.com/coreos/clair