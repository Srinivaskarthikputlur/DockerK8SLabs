# **Docker Capabilities**

### * *

-------

#### Step 1:

* Navigate to the `Docker Capabilities` directory on the provisioned server.

```
cd /root/container-training/Container/DockerCapabilities/
```

-------

#### Step 2:

* Launch an `alpine` container and run ping on `localhost`

```
docker run -it alpine ping -c 1 localhost
```

* Disable/Drop the network syscall `net_raw` and try to ping `localhost` again.

```commandline
docker run --cap-drop=net_raw -it alpine ping -c 1 localhost
```

-------

#### Step 3:

* Disable/Drop All syscalls and only enable the network syscall 

```commandline
docker run --cap-drop=ALL --cap-add=net_raw -it alpine ping -c 1 localhost
```

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:

