# Distroless

### **Lab Image : Containers**

---

* Step 1: Navigate to the `Distroless` directory.

```commandline
cd /root/container-training/Container/distroless/
```

* Step 2: Build the `distroless_flask` docker

```commandline
docker build -t distroless_flask_py .
```

* Step 3: Navigate to the `distroful` directory

```commandline
cd /root/container-training/Container/distroless/distroful
```

* Step 4: Build the `distroful_flask` docker

```commandline
docker build -t distroful_flask_py .
```

* Step 5: Navigate to the `Clair` directory and launch `Clair` Scanner

```commandline
cd /root/container-training/Container/Clair/
```

* Step 6: Start `clair` scanner

```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:latest
```

> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 15
```

* Step 7:  Start clair related database

```commandline
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

> ##### Wait for few seconds till the container is initialized

or

```commandline
sleep 10
```


* Step 8:  Run `clair-scan` against the `distroless_flask` image

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
./clair-scanner --ip $(serverip) -r clair_distroless_flask_report.json distroless_flask_py
```

* Step 9:  Run `clair-scan` against the `distroful_flask` image

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
./clair-scanner --ip $(serverip) -r clair_distroful_flask_report.json distroful_flask_py
```

* Step 10:  Observe the results

* Step 11: Run `http server`

```commandline
python -m SimpleHTTPServer 9090
```

* Step 12: Open another browser tab, on the address bar, add `:9090` and press `Enter`. and check the results.

>> Note: Only `clair_distroful_flask_report.json` results has been written.  

---

## Teardown:

* Stop `http server` using `ctrl + c`

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://github.com/GoogleContainerTools/distroless

* https://www.abhaybhargav.com/stories-of-my-experiments-with-distroless-containers/
