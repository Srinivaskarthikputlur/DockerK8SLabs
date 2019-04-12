# **Kubernetes Hands-on**

### * *

-------

#### Step 1:

* Navigate to the `K8s Hands On` directory on the provisioned server

```commandline
cd /root/container_training/Kubernetes/K8s-Hands-on
```

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Setup a K8s cluster on the provisioned server. Replace `<serverip>` with the public IP of the server provisioned.

```commandline
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address <serverip>
```

* Copy the `config` to communicate with `kube-apiserver` using `kubectl`

```commandline
mkdir -p $HOME/.kube

cp /etc/kubernetes/admin.conf $HOME/.kube/config

chown $(id -u):$(id -g) $HOME/.kube/config
```

-------

#### Step 2:

* Setup a network fabric for k8s with [flannel](https://github.com/coreos/flannel)

```commandline
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
```

* Enable scheduling of pods on the master. [This is disable by default for security reasons](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#control-plane-node-isolation)

```commandline
kubectl taint nodes --all node-role.kubernetes.io/master-
```

-------

#### Step 3:

* After a few minutes, confirm that the k8s cluster is functional

```commandline
kubectl get nodes

kubectl -n kube-system get pods

kubectl get svc
```

-------

#### Step 4:

* Create a `deployment` with an nginx pod running and list the pods

```commandline
kubectl create deployment --image nginx we45-nginx

kubectl get pods
```

* Check the deployment created and scale it.

```commandline
kubectl get deployment

kubectl scale deployment --replicas 3 we45-nginx

kubectl get pods
```

* Create a `Service` to expose the deployment within the cluster for pods on other nodes to communicate with the service

```commandline
kubectl expose deployment we45-nginx --port=80 --type=NodePort

kubectl get services
```

### *There are 3 Types of services:*
* #### `ClusterIP` - IP of service accessible within the cluster
* #### `NodePort` - Service is accessible within the cluster and accessed from outside the cluster with NodeIP:NodePort
* #### `LoadBalancer` - Provides a Public IP that can be accessed and loadbalances the traffic to the service if it's running on multiple nodes

* Access the nginx service on the browser

```commandline
# Fetch the IP of the provisioned server
serverip

http://<serverip>:<nodePort>
```

-------

#### Step 5:

* Delete the service and deployment 

```commandline
kubectl delete service we45-nginx

kubectl delete deployment we45-nginx

kubectl get service

kubectl get deployment

kubectl get pods
```

-------

#### Step 6:

* Create a separate kubernetes `namespace` and run services in it

```commandline
kubectl create namespace wecare

kubectl get namespace
```

* Using the `YAML spec`, create a `deployment` and a `service`.

```commandline
kubectl -n wecare create -f wecare-deployment.yaml

kubectl -n wecare create -f wecare-service.yaml

kubectl get deployment

kubectl -n wecare get deployment

kubectl -n wecare get service
```

* The `NodePort` service can be accessed on the browser

```commandline
# Fetch the IP of the provisioned server
serverip

http://<serverip>:<nodePort>
```

-------

#### Step 7:

* The `service` and `deployment` can be deleted by deleting the `namespace`.

```commandline
kubectl delete ns wecare
```

---------

### Reading Material/References:
