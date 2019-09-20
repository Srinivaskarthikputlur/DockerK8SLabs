# AppArmor

>Runtime Protection for Container Workloads

### **Lab Image : Containers**

---
## Without AppArmor

* Step 1:  Navigate to the `AppArmor` directory.

```
cd /root/container-training/Container/AppArmor/
```

* Step 2: Multiplex terminal session with `tmux` and split panes.

```commandline
tmux
```

```commandline
tmux split-window -h
```
* Step 3: start a `netcat` listener.

```commandline
nc -l 1337
```

* Step 4: Go to the left pane using `ctrl` + `b` and then `left arrow key`

* Step 5: Run docker container

```commandline
docker run -d -p 5050:5050 abhaybhargav/vul_flask
```

* Step 6: `cd` into the `cd /root/container-training/Container/AppArmor/`

```commandline
cd /root/container-training/Container/AppArmor/
``` 

* Step 7: Change the reverse shell ip 

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
sed -i -e 's/Server_IP_Here/'"$(serverip)"'/g' reverse_shell.yml
```

* Step 8: Upload the edited `reverse_shell.yml` to the `abhaybhargav/vul_flask` application running on port `5000`

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
http --form POST http://$(serverip):5050/yaml_hammer file@reverse_shell.yml submit=submit
```

* Step 9: If the command has successfully executed, the reverse tcp shell in the right panel should be working. To run commands on the shell, switch to the right panel. using `ctrl` + `b` and then `right arrow key` 


* Step 10: With a reverse-shell on the container, commands can be run on it.

```commandline
ls
```

```commandline
cat /etc/passwd
```

```commandline
cat app.py
```

### Teardown

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

## With AppArmor
> Let's try and prevent the same attack using `Apparmor`

* Step 1:  Navigate to the `AppArmor` directory.

```
cd /root/container-training/Container/AppArmor/
```

* Step 2: Multiplex terminal session with `tmux` and split panes.

```commandline
tmux
```

```commandline
tmux split-window -h
```
* Step 3: start a `netcat` listener.

```commandline
nc -l 1337
```

* Step 4: Go to the left pane using `ctrl` + `b` and then `left arrow key`


* Step 5: Load the apparmor profile to the provisioned server

```commandline
apparmor_parser -r -W vul-flask-armor
```

* Step 6: Launch the same `abhaybhargav/vul_flask` container, with the apparmor profile attached.

```commandline
docker run -d --name vul_flask -p 5050:5050 --security-opt apparmor=vul-flask-armor abhaybhargav/vul_flask
```

* Step 7: `cd` into the `cd /root/container-training/Container/AppArmor/`

```commandline
cd /root/container-training/Container/AppArmor/
``` 

* Step 8: Upload the edited `reverse_shell.yml` to the `abhaybhargav/vul_flask` application running on port `5000`

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
http --form POST http://$(serverip):5050/yaml_hammer file@reverse_shell.yml submit=submit
```

> **NOTE**: It can be observed that the reverse-shell was unsuccessful

* Step 9: Go to the right pane using `ctrl` + `b` and then `right arrow key`

* Step 10: Type `ls` command and weather you have achieved persistence through the reverse shell.

* Step 11: Go to the left pane using `ctrl` + `b` and then `left arrow key`

* Step 12: Try `exec` into the container

```commandline
docker exec -it vul_flask bash
```

* Step 13:  Inside the container environment, try to create or access files.

```commandline
cat /etc/passwd
```
```commandline
touch shell.py
```
```commandline
touch /tmp/shell.py
```

> **NOTE**: The reverse-shell and the commands do not work because we enabled the runtime security profile with AppArmor

### Teardown

* Step 14: Exit from the container

```commandline
exit
```
* Step 15: Exit from the `tmux` shell

```commandline
exit
```

```commandline
exit
```

* Step 16: Stop all containers

```commandline
clean-docker
```

### Reading Material/References:

* https://docs.docker.com/engine/security/apparmor/

* https://gitlab.com/apparmor/apparmor
