# **AppArmor**

### *Runtime Protection for Container Workloads*

### **Lab Image : `Containers`**

---

#### Step 1:

* Navigate to the `AppArmor` directory on the provisioned server.

```
cd /root/container-training/Container/AppArmor/
```

* Multiplex terminal session with `tmux` and split panes horizontally.

```commandline
tmux
```
```commandline
tmux split-window -v
```

---

#### Step 2:

* Go to the lower panel and start a `netcat` listener.

> ###### Switch to the lower panel with `ctrl` + `b` and then `lower arrow key`

```commandline
nc -l 1337
```

* Go to the upper pane to launch the `abhaybhargav/vul_flask` container

> ###### Switch to the upper pane with `ctrl` + `b` and then `upper arrow key`

```commandline
docker run -d -p 5050:5050 abhaybhargav/vul_flask
```

---

#### Step 3:

* Fetch the Public IP Address of the provisioned server

```commandline
serverip
```

* Edit `reverse_shell.yml` by substituting `<IP>` with the Public IP Address fetched in the previous step

> **EXAMPLE**: `sed -i -e 's/Server_IP_Here/192.168.1.1/g' reverse_shell.yml`

```commandline
sed -i -e 's/Server_IP_Here/'"$(serverip)"'/g' reverse_shell.ymll
```

* Confirm if `reverse_shell.yml` has been edited.

```commandline
cat reverse_shell.yml
```

---

#### Step 4:

* Upload the edited `reverse_shell.yml` to the `abhaybhargav/vul_flask` application running on port `5000`

> **EXAMPLE**: `http --form POST http://192.168.1.1:5050/yaml_hammer file@reverse_shell.yml submit=submit`

```commandline
http --form POST http://$(serverip):5050/yaml_hammer file@reverse_shell.yml submit=submit
```

* If the command has successfully executed, the reverse tcp shell in the lower panel should be working. To run commands on the shell, switch to the lower panel.

> ###### Switch to the lower panel with `ctrl` + `b` and then `lower arrow key`

* With a reverse-shell on the container, commands can be run on it.

```commandline
ls
```
```commandline
cat /etc/passwd
```
```commandline
cat app.py
```

* Go back to the upper pane and stop all containers. Running this will terminate the reverse-shell.

> ###### Switch to the upper pane with `ctrl` + `b` and then `upper arrow key`

```commandline
clean-docker
```

---

> #### **Let's try and prevent the same attack using `Apparmor`**:

---

#### Step 5:

* Load the apparmor profile to the provisioned server

```commandline
apparmor_parser -r -W vul-flask-armor
```

* Launch the same `abhaybhargav/vul_flask` container, with the apparmor profile attached.

```commandline
docker run --rm -d -p 5050:5050 --security-opt apparmor=vul-flask-armor abhaybhargav/vul_flask
```

---

#### Step 6:

* Switch to the lower panel and setup the netcat listner

> ###### Switch to the lower pane with `ctrl` + `b` and then `lower arrow key`

```commandline
ctrl + b + (lower arrow key) 
```
```commandline
nc -l 1337
```

* In the upper panel, upload the `reverse_shell.yml` file similar to **Step 4**

> **EXAMPLE**: `http --form POST http://192.168.1.1:5050/yaml_hammer file@reverse_shell.yml submit=submit`

```commandline
http --form POST http://$(serverip):5050/yaml_hammer file@reverse_shell.yml submit=submit
```

> **NOTE**: It can be observed that the reverse-shell was unsuccessful

---

#### Step 7:

* Fetch the `Container ID` and try to `exec` into the `abhaybhargav/vul_flask` container.

```commandline
docker ps
```

> **EXAMPLE**: `docker exec -ti fc4e7ea5e6f3 bash`

```commandline
docker exec -ti <CONTAINER ID> bash
```

* Inside the container environment, try to create/access files

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

---

#### Step 8:

* Exit from the `tmux` sessions and stop all the containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://docs.docker.com/engine/security/apparmor/

* https://gitlab.com/apparmor/apparmor