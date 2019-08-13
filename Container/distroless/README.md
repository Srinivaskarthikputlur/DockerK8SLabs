# **Distroless**

### * *

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `Distroless` directory on the provisioned server

```commandline
cd /root/container-training/Container/distroless/
```

---

#### Step 2:

* Build the `distroless_flask` docker

```commandline
docker build -t distroless_flask_py .
```

* Navigate to the `distroful` directory

```commandline
cd /root/container-training/Container/distroless/distroful
```

* Build the `distroful_flask` docker

```commandline
docker build -t distroful_flask_py .
```

---

#### Step 3:

* Navigate to the `Clair` directory and launch `Clair` Scanner

```commandline
cd /root/container-training/Container/Clair/
```
```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:2019-01-01
```

> ##### Wait for few seconds till the container is initialized

docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

---

#### Step 4:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Run `clair-scan` against the `distroless_flask` image

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json distroless_flask_py
```

> **EXAMPLE**: `./clair-scanner --ip 104.1.1.1 -r clair_report.json distroless_flask_py`

* Run `clair-scan` against the `distroful_flask` image

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json distroful_flask_py
```

> **EXAMPLE**: `./clair-scanner --ip 104.1.1.1 -r clair_report.json distroful_flask_py`

* Observe the results

---

#### Step 5:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://github.com/GoogleContainerTools/distroless

* https://www.abhaybhargav.com/stories-of-my-experiments-with-distroless-containers/