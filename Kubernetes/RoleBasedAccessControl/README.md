# **Role Based Access Control**


### * *

-------

#### Step 1:

* Navigate to the `RoleBasedAccessControl` directory on the provisioned server.

```commandline
cd /root/container_training/Kubernetes/RoleBasedAccessControl
```

-------

#### Step 2:

* Generate an ssl key for `restricteduser`

```commandline
sudo openssl genrsa -out restricteduser.key 4096
```

* Generate a certificate using they key created in the previous step

```commandline
sudo openssl req -new -key restricteduser.key -out restricteduser.csr -subj '/CN=restricteduser/O=developer'
```

* Generate a self-signed key for k8s with the Cluster CA

```commandline
sudo openssl x509 -req -in restricteduser.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out restricteduser.crt -days 365
```

-------

#### Step 3:

* Create a restricted namespace

```commandline
kubectl create namespace restricted-namespace
```

* Set credentials and context for the user `restricteduser`

```commandline
kubectl config set-credentials restricteduser --client-certificate=restricteduser.crt  --client-key=restricteduser.key

kubectl config set-context restricteduser-context --cluster=kubernetes --namespace=restricted-namespace --user=restricteduser
```

* Try fetching the list of pods with `restricteduser-context`

```commandline
kubectl --context=restricteduser-context get pods
```

#### **It will show the following Error: `Error from server (Forbidden): pods is forbidden: User "restricteduser" cannot list pods in the namespace "restricted-namespace"`**

-------

#### Step 4:

* Create a Role and RoleBinding in `restricted-namespace`

```commandline
kubectl -n restricted-namespace create -f role-deployment-manager.yaml

kubectl -n restricted-namespace create -f rolebinding-deployment-manager.yaml
```

* Run a pod using `restricteduser-context`

```commandline
kubectl --context=restricteduser-context run --image nginx:alpine nginx
```

-------

#### Step 5:

* Using the restricteduser-context, try deleting the pod running

```commandline
kubectl --context=restricteduser-context get pods 

kubectl --context=restricteduser-context delete pod <pod_name>
```

#### **It will show the following Error: `Error from server (Forbidden): pods "nginx-xxxxxxxxxx-xxxxx" is forbidden: User "restricteduser" cannot delete pods in the namespace "restricted-namespace"`**

-------

#### Step 6:

* To Remove the `Role`, `RoleBinding` and the `Pod`, delete the `restricted-namespace`. 

```commandline
kubectl delete ns restricted-namespace
```

---------

### Reading Material/References:

