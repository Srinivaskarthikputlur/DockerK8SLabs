# Resource Management

> Restricting host resources for a container

### **Lab Image : Containers**

---

* Step 1: Launch a container and restrict the `CPU utilization`.

```commandline
docker run -it --cpus=".5" ubuntu:latest /bin/bash
```

* Step 2:Install `stress` on the container

```commandline
apt update && apt install stress -y
```

* Step 3: Stress test the `CPU utilization` for 5 seconds and observe the results

```commandline
stress --cpu 10 --timeout 5
```

## Teardown

* Step 4: Exit from the container

```commandline
exit
```

* Step 5: Stop all containers

```commandline
clean-docker
```

### Reading Material/References:

* https://hub.docker.com/r/progrium/stress/

