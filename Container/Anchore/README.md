# **Anchore**

---

> #### [Anchore](https://anchore.com/opensource/) engine helps perform detailed analysis on container images that can be easily integrated in CI/CD pipelines.

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `Anchore` directory on the provisioned server.

```commandline
cd /root/container-training/Container/Anchore/
```

---

#### Step 2:

* Launch [`Anchore Engine`](https://github.com/anchore/anchore-engine) that can be accessed via. REST API

```commandline
docker-compose up -d
```
```commandline
docker ps
```

> **NOTE**: We will have an separate section on `docker-compose` soon!*

---

#### Step 3:

* Add an image to the Anchore Engine

```commandline
anchore-cli image add abhaybhargav/vul_flask:latest
```

* List the image analyzed by Anchore and fetch a specific image when once the status is `Analyzed`(This might take a while....)

```commandline
anchore-cli image list
```
```commandline
anchore-cli image get docker.io/abhaybhargav/vul_flask:latest
```

* Perform a vulnerability scan on the image 

```commandline
anchore-cli image vuln docker.io/abhaybhargav/vul_flask:latest
```

* List out the `os` and `language` related issues present in the image and fetch the details

```commandline
anchore-cli image content docker.io/abhaybhargav/vul_flask:latest os
```
```commandline
anchore-cli image content docker.io/abhaybhargav/vul_flask:latest python
```

---

> **EXERCISE**: Try to perform a vulnerability scan on a distroless image and observe the results

---

#### *Teardown*:

* Stop all containers

```commandline
docker-compose down
```
```commandline
clean-docker
```

---

### Reading Material/References:

* https://github.com/anchore/anchore

* https://github.com/anchore/anchore-engine

* https://anchore.com/opensource/

* https://sysdig.com/blog/container-security-docker-image-scanning/
