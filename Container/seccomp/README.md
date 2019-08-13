# **SecComp**

### *Secure Computing Profiles for Docker*

### **Lab Image : `Containers`**

-------

#### Step 1:

* Navigate to the `SecComp` directory on the provisioned server.

```
cd /root/container-training/Container/seccomp/
```

-------

#### Step 2:

* Go through the `custom_profile.json`, the example SecComp profile we'll be using

```commandline
cat custom_profile.json
```

> **NOTE**: The SecComp profile blocks `chmod`, `chown` and `chown32` when loaded onto a container

-------

#### Step 3:

* Launch a container and try using the `chmod` command. Observer the results

```commandline
docker run -it --rm --security-opt seccomp:custom_profile.json alpine chmod 400 /etc/hostname
```

-------

#### Step 4:

* Stop all containers

```commandline
clean-docker
```

---------

### Reading Material/References:

* http://man7.org/linux/man-pages/man2/seccomp.2.html

* https://docs.docker.com/engine/security/seccomp/