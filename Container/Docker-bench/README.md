# **Dockerbench**

### *Docker-bench checks for common best-practices inspired from Docker-CIS-Benchmark when deploying docker containers in production. (https://www.cisecurity.org/benchmark/docker/)*

-------

#### Step 1:

* Navigate to the `docker-bench` directory on the provisioned server

```commandline
cd /root/container-training/Container/Docker-bench/
```

-------

#### Step 2:

* Run the Docker-bench container

```commandline
docker run -it --net host --pid host --userns host --cap-add audit_control -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST -v /var/lib:/var/lib -v /var/run/docker.sock:/var/run/docker.sock -v /usr/lib/systemd:/usr/lib/systemd -v /etc:/etc --label docker_bench_security docker/docker-bench-security
```

#####  **The command exposes all the necessary host resources and volumes to run the scan**

-------

#### Step 3:

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:

* https://www.cisecurity.org/benchmark/docker/

* https://github.com/aquasecurity/docker-bench

