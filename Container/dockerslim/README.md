# **DockerSlim**

### *Minify "bloated" containers making it secure by decreasing the attack surface and using the 'auto-generated' SecComp profiles*

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `DockerSlim` directory on the provisioned server.

```commandline
cd /root/container-training/Container/dockerslim/
```

* Install `docker-slim`

```commandline
wget https://downloads.dockerslim.com/releases/1.25.0/dist_linux.tar.gz && tar -xvzf dist_linux.tar.gz && mv dist_linux/* /usr/local/bin/
```

* Ensure that `docker-slim` has been installed successfully

```commandline
docker-slim --help
```

---

#### Step 2:

* Pull the latest `abhaybhargav/vul_flask` image that will be used to minify.

```commandline
docker pull abhaybhargav/vul_flask
```

* The `probeCmds.json` file has the list of `http` calls used in the `vul_flask` app. This helps `docker-slim` generate AppArmor and SecComp profile.

```commandline
cat probeCmds.json
```

---

#### Step 3:

* Build the `docker-slim` image and observe the logs.

```commandline
docker-slim build --show-clogs --http-probe-cmd-file probeCmds.json abhaybhargav/vul_flask
```

* Fetch the docker `IMAGE ID` of `abhaybhargav/vul_flask`

```commandline
docker images --no-trunc | grep abhaybhargav/vul_flask
```

> **EXAMPLE**: `abhaybhargav/vul_flask  latest  sha256:9ac6b79cd152209c1311c319fd50658cf456ec3291e8b8803006ce3c8a51e506  15 months ago  763MB`

* It can be observed that the `http` calls were made and the `AppArmor` and `SecComp` profiles were generated.

> **EXAMPLE**: `cd /usr/local/bin/.docker-slim-state/images/9ac6b79cd152209c1311c319fd50658cf456ec3291e8b8803006ce3c8a51e506/artifacts/ `

```commandline
cd /usr/local/bin/.docker-slim-state/images/<docker_image_id>/artifacts/
```
```commandline
ls
```

* Observe the difference is size of the images

```commandline
docker images
```

---

#### Step 4:

* Navigate to the `Clair` directory and launch `Clair` Scanner

```commandline
cd /root/container-training/Container/Clair/
```
```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:2019-01-01
```

> ##### Wait for few seconds till the container is initialized

```commandline
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

---

#### Step 5:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Run `clair-scan` against the `abhaybhargav/vul_flask` image

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json abhaybhargav/vul_flask
```

> **EXAMPLE**: `./clair-scanner --ip 104.1.1.1 -r clair_report.json abhaybhargav/vul_flask`

* Run `clair-scan` against the `abhaybhargav/vul_flask.slim` image

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json abhaybhargav/vul_flask.slim
```

> **EXAMPLE**: `./clair-scanner --ip 104.1.1.1 -r clair_report.json abhaybhargav/vul_flask.slim`

* Observe the results

---

#### Step 6:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://dockersl.im/

* https://github.com/docker-slim/docker-slim

* https://youtu.be/FOSLxa6-fuY?t=459