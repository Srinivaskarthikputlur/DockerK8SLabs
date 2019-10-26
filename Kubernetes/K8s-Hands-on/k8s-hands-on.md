# Kubernetes Hands-on

### **Lab Image : Kubernetes**

---

* Step 1: Navigate to the `K8s Hands On` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/K8s-Hands-on
```

* Step 2: Setup a K8s cluster on the provisioned server. Replace `<serverip>` with the public IP of the server provisioned.

```commandline
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $(serverip)
```

* Step 3: Copy the `config` to communicate with `kube-apiserver` using `kubectl`

```commandline
mkdir -p $HOME/.kube
```
```commandline
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```
```commandline
chown $(id -u):$(id -g) $HOME/.kube/config
```

* Step 4: Setup a network fabric for k8s with [flannel](https://github.com/coreos/flannel)

```commandline
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
```commandline
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
```

* Step 5: Enable scheduling of pods on the master. [This is disabled by default for security reasons](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#control-plane-node-isolation)

```commandline
kubectl taint nodes --all node-role.kubernetes.io/master-
```

* Step 6: After a few minutes, confirm that the k8s cluster is functional

```commandline
kubectl get nodes
```
```commandline
kubectl -n kube-system get pods
```
```commandline
kubectl get svc
```

* Step 7: Create a `deployment` with an nginx pod running and list the pods

```commandline
kubectl create deployment --image nginx we45-nginx
```
```commandline
kubectl get pods
```

* Step 8: Check the deployment created and scale it.

```commandline
kubectl get deployment
```
```commandline
kubectl scale deployment --replicas 3 we45-nginx
```
```commandline
kubectl get pods
```

* Step 9: Create a `Service` to expose the deployment within the cluster for pods on other nodes to communicate with the service

```commandline
kubectl expose deployment we45-nginx --port=80 --type=NodePort
```
```commandline
kubectl get services
```

### *There are 3 Types of services:*
* #### `ClusterIP` - IP of service accessible within the cluster
* #### `NodePort` - Service is accessible within the cluster and accessed from outside the cluster with NodeIP:NodePort
* #### `LoadBalancer` - Provides a Public IP that can be accessed and loadbalances the traffic to the service if it's running on multiple nodes

* Step 11: Fetch the IP of the provisioned server

```commandline
serverip
```

* Step 12: Access the nginx service on the browser

```commandline
http://<serverip>:<nodePort>
```

* Step 13: Delete the service and deployment 

```commandline
kubectl delete service we45-nginx
```
```commandline
kubectl delete deployment we45-nginx
```
```commandline
kubectl get service
```
```commandline
kubectl get deployment
```
```commandline
kubectl get pods
```

* Step 14: Create a separate kubernetes `namespace` and run services in it

```commandline
kubectl create namespace wecare
```
```commandline
kubectl get namespace
```

* Step 15: Using the `YAML spec`, create a `deployment` and a `service`.

```commandline
kubectl -n wecare create -f wecare-deployment.yaml
```
```commandline
kubectl -n wecare create -f wecare-service.yaml
```
```commandline
kubectl get deployment
```
```commandline
kubectl -n wecare get deployment
```
```commandline
kubectl -n wecare get service
```

* Step 16: The `NodePort` service can be accessed on the browser

```commandline
serverip
```
```commandline
http://<serverip>:<nodePort>
```

## Teardown

* Step 1: The `service` and `deployment` can be deleted by deleting the `namespace`.

```commandline
kubectl delete ns wecare
```
