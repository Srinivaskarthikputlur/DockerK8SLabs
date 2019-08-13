# **Resource Management**

### *Restricting host resources for a container*

### **Lab Image : `Containers`**

---

#### Step 1:

* Host resources such as `Storage`, `CPU` and `Memory` can be restricted when running a container

```commandline
--storage-opt           Storage driver
--cpus                  Number of CPUs
-m                      Memory Size 
```

* Launch a container and restrict the CPU utilization.

```commandline
docker run -it --cpus=".5" ubuntu:latest /bin/bash
```

---

#### Step 2:

* Install `stress` on the container

```commandline
apt update
```
```commandline
apt install stress
```

* Stress test the CPU utilization for 5 seconds and observe the results

```commandline
stress --cpu 10 --timeout 5
```

---

#### Step 3:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

