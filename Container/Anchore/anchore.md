# Anchore

> Anchore engine helps perform detailed analysis on container images that can be easily integrated in CI/CD pipelines.

### **Lab Image : Containers**

---

* Step 1: Navigate to the `Anchore` directory on the provisioned server.

```commandline
cd /root/container-training/Container/Anchore/
```

* Step 2: Launch Anchore

```commandline
docker-compose up -d
```
> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 15
```

* Step 3: Add an image to the Anchore Engine

```commandline
anchore-cli image add abhaybhargav/vul_flask:latest
```

* Step 4: List the image analyzed by Anchore and fetch a specific image when once the status is `Analyzed`(This might take a while....)

```commandline
anchore-cli image list
```

```commandline
anchore-cli image get docker.io/abhaybhargav/vul_flask:latest
```

* Step 5: Perform a vulnerability scan on the image 

```commandline
anchore-cli image vuln docker.io/abhaybhargav/vul_flask:latest
```

* Step 6: List out the `os` and `language` related issues present in the image and fetch the details

```commandline
anchore-cli image content docker.io/abhaybhargav/vul_flask:latest os
```

```commandline
anchore-cli image content docker.io/abhaybhargav/vul_flask:latest python
```

## Teardown

* Stop all containers

```commandline
cd /root/container-training/Container/Anchore/
```

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
