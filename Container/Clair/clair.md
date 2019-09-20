# Clair
>Vulnerability Static Analysis for Containers

### **Lab Image : Containers**
---

* Step 1: Navigate to the `Clair` directory and launch `Clair` Scanner

```commandline
cd /root/container-training/Container/Clair/
```

* Step 2: Start `clair` scanner

```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:latest
```

> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 15
```

* Step 3:  Start clair related database

```commandline
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 10
```

* Step 4: Pull the image to be scanned

```commandline
docker pull abhaybhargav/vul_flask:latest
```

* Step 5: Run Clair scan against the image and generate a `json` report

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json abhaybhargav/vul_flask:latest
```

* Step 6: Run `http server`

```commandline
python -m SimpleHTTPServer 9090
```

* Step 7: Open another browser tab, on the address bar, add `:9090` and press `Enter`. and check the results.


### Teardown:

* Step 8: Stop `http server` using `ctrl + c`

* Step 9: Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://github.com/coreos/clair
