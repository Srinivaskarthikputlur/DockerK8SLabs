# **Kata Containers**

### *Lightweight virtual machines that feel and perform like containers, but provide stronger workload isolation using hardware virtualization technology*

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `Kata Containers` directory on the provisioned server.

```commandline
cd /root/container-training/Container/katacontainers/
```

* Ensure that `docker` has been installed successfully

```commandline
docker images
```
```commandline
docker ps
```

---

#### Step 2:

* Install [`KataContainers`](https://katacontainers.io/) on the provisioned server

```commandline
ARCH=$(arch)
```
```commandline
BRANCH="${BRANCH:-master}"
```
```commandline
sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list"
```
```commandline
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/${BRANCH}/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
```
```commandline
apt-get update && apt-get -y install kata-runtime kata-proxy kata-shim
```

---

#### Step 3:

* Configure `docker` to use `Katacontainer`

```commandline
mkdir -p /etc/systemd/system/docker.service.d/
```
```commandline
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/kata-containers.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D --add-runtime kata-runtime=/usr/bin/kata-runtime --default-runtime=kata-runtime
EOF
```

* Add the following definitions to `/etc/docker/daemon.json`.

```json
{
  "default-runtime": "kata-runtime",
  "runtimes": {
    "kata-runtime": {
      "path": "/usr/bin/kata-runtime"
    }
  }
}
```

---

#### Step 4:

* Restart the daemon and docker service

```commandline
systemctl daemon-reload
```
```commandline
systemctl restart docker
```

* Verify that docker is running using `katacontainers`

```commandline
uname -a
```
```commandline
docker run alpine  uname -a
```

> **EXAMPLE**: The kernel on `alpine` container is different because `docker` is configured to use `katacontainer` and not the host-machine kernel. This feature makes `katacontainers` more isolated and secure

---

#### Step 5:

* Check the modules loaded on host-machine and container

```commandline
lsmod
```
```commandline
docker run -ti --rm --privileged -v /:/hostFS/ alpine lsmod
```

* Launch a container and try to deleting the host modules

```commandline
docker run -ti --rm --privileged -v /:/hostFS/ alpine sh
```
```commandline
rmmod floppy /hostFS
```

* Exit from the container

```commandline
exit
```

> **NOTE**: It can be observed that removing the `host` modules is not possible with `kataconatiners`

---

> **EXERCISE**: Try to launch a container with the `docker.sock` mounted and observe the results

---

#### Step 6:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

