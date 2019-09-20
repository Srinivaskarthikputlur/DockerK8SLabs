# **Dive**

---

> #### Exploring Docker image(s) and layer contents with [`Dive`](https://github.com/wagoodman/dive/)

### **Lab Image : Containers**

* Step 1: Pull the image to be analyzed.

```commandline
docker pull abhaybhargav/vul_flask
```

* Step 2: Run dive on the docker image and wait for image analysis and details

```commandline
dive abhaybhargav/vul_flask
```

---

### Teardown

* To exit from the `dive` window. Press `ctrl + c`

```commandline
ctrl + c
```


### Reading Material/References:

* https://github.com/wagoodman/dive/
