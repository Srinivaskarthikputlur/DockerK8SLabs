# **Trusted Images**

### *Ensuring the integrity and the publisher of all the data a system operates on with content-trust*

-------

#### Step 1:

* Register/Login on [DockerHub](https://hub.docker.com/)

```commandline
https://hub.docker.com/
```

* On the provisioned server, login with DockerHub credentials

```commandline
docker login
```

-------

#### Step 2:

* Tag an image(`alpine`) using DockerHub username.

```commandline
docker tag alpine <username>/untrusted:latest
```

* Push the `<username>/untrusted:latest` image to DockerHub

```commandline
docker push <username>/untrusted:latest
```

-------

#### Step 2:

* Enable [Content Trust](https://docs.docker.com/engine/security/trust/content_trust/) on the server provisioned

```commandline
export DOCKER_CONTENT_TRUST=1

```

* Try to pull the `<username>/untrusted:latest` image from DockerHub and observe the results

```commandline
docker pull <username>/untrusted:latest
```

-------

#### Step 3:

* With `Content Trust` enabled, tag an `alpine` image using DockerHub username

```commandline
docker tag alpine <username>/trusted:latest
```

* Push the `<username>/trusted:latest` image to DockerHub

```commandline
docker push <username>/trusted:latest
```

------

###  ** Note: You will be prompted to create a new root signing key passphrase. 

----

#### Step 4:

* Pull the `<username>/trusted:latest` image from DockerHub Repository.

```commandline
docker pull <username>/trusted:latest
```

* It can be observed that only signed images can be pulled.

###  ** Note: Check `~/.docker/trust/private` for private keys

----

#### Step 5:

* Inspect the `untrusted` and `trusted` docker images

```commandline
docker trust inspect <username>/untrusted:latest

docker trust inspect <username>/trusted:latest
```

----

#### Step 6:

* Disable `Content Trust` to pull images for other exercises

```commandline
export DOCKER_CONTENT_TRUST=0
```

-------


### Reading Material/References:

