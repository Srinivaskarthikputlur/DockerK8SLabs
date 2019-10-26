# DockerSlim

> Minify "bloated" containers making it secure by decreasing the attack surface and using the 'auto-generated' SecComp profiles

### **Lab Image : Containers**

---

* Step 1: Navigate to the `DockerSlim` directory on the provisioned server.

```commandline
cd /root/container-training/Container/dockerslim/
```

* Step 2: Pull the latest `abhaybhargav/vul_flask` image that will be used to minify.

```commandline
docker pull abhaybhargav/vul_flask
```

* Step 3: The `probeCmds.json` file has the list of `http` calls used in the `vul_flask` app.
 
 This helps `docker-slim` generate AppArmor and SecComp profile.

```commandline
cat probeCmds.json
```

* Step 4: Build the `docker-slim` image and observe the logs.

```commandline
docker-slim build --show-clogs --http-probe-cmd-file probeCmds.json abhaybhargav/vul_flask
```

* Step 5: Fetch the docker `IMAGE ID` of `abhaybhargav/vul_flask`

```commandline
docker images --no-trunc | grep abhaybhargav/vul_flask
```

>>EXAMPLE: `abhaybhargav/vul_flask  latest  sha256:9ac6b79cd152209c1311c319fd50658cf456ec3291e8b8803006ce3c8a51e506  15 months ago  763MB`

* Step 6: It can be observed that the `http` calls were made and the `AppArmor` and `SecComp` profiles were generated.

>>EXAMPLE: `cd /usr/local/bin/.docker-slim-state/images/9ac6b79cd152209c1311c319fd50658cf456ec3291e8b8803006ce3c8a51e506/artifacts/ `

```commandline
cd /usr/local/bin/.docker-slim-state/images/<docker_image_id>/artifacts/
```

```commandline
ls
```

* Step 7: Run `http server`

```commandline
python -m SimpleHTTPServer 9090
```
* Step 8: Open another browser tab, on the address bar, add `:9090` and press `Enter`. and check the results.

* Step 9: Stop `http server` using `ctrl + c`

* Step 10: Observe the difference is size of the images between `abhaybhargav/vul_flask.slim` and `abhaybhargav/vul_flask` image.

```commandline
docker images
```

### Scan against the docker images

* Step 11: Navigate to the `Clair` directory and launch `Clair` Scanner

```commandline
cd /root/container-training/Container/Clair/
```

* Step 12: Start `clair` scanner

```commandline
docker run -d -p 5432:5432 --name db arminc/clair-db:latest
```

> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 15
```

* Step 13:  Start clair related database

```commandline
docker run -d -p 6060:6060 --link db:postgres --name clair arminc/clair-local-scan:v2.0.1
```

> ##### Wait for few seconds till the container is initialized

or 

```commandline
sleep 10
```

* Step 14: Run `clair-scan` against the `abhaybhargav/vul_flask` image

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
./clair-scanner --ip $(serverip) -r clair_report.json abhaybhargav/vul_flask
```

* Step 15: Run `clair-scan` against the `abhaybhargav/vul_flask.slim` image

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
./clair-scanner --ip $(serverip) -r clair_slim_report.json abhaybhargav/vul_flask.slim
```

* Step 16:  Observe the results

* Step 17: Run `http server`

```commandline
python -m SimpleHTTPServer 9090
```

* Step 18: Open another browser tab, on the address bar, add `:9090` and press `Enter`. and check the results.

>> Note: Only `clair_report.json` results has been written.  

---

## Teardown

* Step 19: Stop `http server` using `ctrl + c`

* Step 20: Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://dockersl.im/

* https://github.com/docker-slim/docker-slim

* https://youtu.be/FOSLxa6-fuY?t=459
