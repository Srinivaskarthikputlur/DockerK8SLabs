# **KubeHunter**


### *Scanning a K8s cluster for vulnerabilities*

-------

#### Step 1:

* Navigate to the `KubeHunter` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/Kube-Hunter
```

-------

#### Step 2:

* Get the list of arguments available

```commandline
docker run -it --rm --network host aquasec/kube-hunter --help

docker run -it --rm --network host aquasec/kube-hunter --active --list
```

-------

#### Step 3:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Start a `KubeHunter` scan on the K8s cluster running on the provisioned server

```commandline
docker run -it --rm --network host aquasec/kube-hunter

# Select 'Option 1' and enter the IP of the provisioned server
```

---------

### Reading Material/References:

* https://github.com/aquasecurity/kube-hunter

* https://kube-hunter.aquasec.com/