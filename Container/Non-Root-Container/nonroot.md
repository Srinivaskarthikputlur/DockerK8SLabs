# Non-root Container

> Preventing `Container Breakout` using `Non-root`

### **Lab Image : Containers**

* Step 1: Validate that you are the `root` user on the provisioned server

```commandline
whoami
```

* Step 2: Validate that there's a secret file in the root directory

```commandline
cat /root/secret.txt
```

* Step 3: Launch a docker container with non-root(ie., `uid != 0`) and volume expose the host machine root filesystem

```commandline
docker run -ti --rm -u 1000 -v /root:/hostFS/ alpine sh
```

* Step 4:  On the container, try to read the secret file.

```commandline
cat /hostFS/secret.txt
```

```commandline
cd /hostFS
```

* Exit from the container

```commandline
exit
```

## Teardown

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://engineering.docker.com/2019/02/experimenting-with-rootless-docker/
