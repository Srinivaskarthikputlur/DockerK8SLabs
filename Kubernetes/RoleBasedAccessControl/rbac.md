## Role Based Access Control
---

#### **Lab Image : Kubernetes**

* Step 1: Navigate to the `RoleBasedAccessControl` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/RoleBasedAccessControl
```

* Step 2: Generate an ssl key for `restricteduser`

```commandline
sudo openssl genrsa -out restricteduser.key 4096
```

* Step 3: Generate a certificate using they key created in the previous step

```commandline
sudo openssl req -new -key restricteduser.key -out restricteduser.csr -subj '/CN=restricteduser/O=developer'
```

* Step 4: Generate a self-signed key for k8s with the Cluster CA

```commandline
sudo openssl x509 -req -in restricteduser.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out restricteduser.crt -days 365
```

* Step 5: Create a restricted namespace

```commandline
kubectl create namespace restricted-namespace
```

* Step 6: Set credentials and context for the user `restricteduser`

```commandline
kubectl config set-credentials restricteduser --client-certificate=restricteduser.crt  --client-key=restricteduser.key
```
```commandline
kubectl config set-context restricteduser-context --cluster=kubernetes --namespace=restricted-namespace --user=restricteduser
```

* Step 7: Using [`can-i`](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access), check to see if `restricteduser-context` user has access to fetch pods

```commandline
kubectl --context=restricteduser-context auth can-i get pods
```

* Step 8: Confirm by trying to fetch the list of pods with `restricteduser-context`

```commandline
kubectl --context=restricteduser-context get pods
```

> **NOTE**: It will show the following Error: `Error from server (Forbidden): pods is forbidden: User "restricteduser" cannot list pods in the namespace "restricted-namespace"`

* Step 9: Create a Role and RoleBinding in `restricted-namespace`

```commandline
kubectl -n restricted-namespace create -f role-deployment-manager.yaml
```
```commandline
kubectl -n restricted-namespace create -f rolebinding-deployment-manager.yaml
```

* Step 10: Confirm that `restricteduser-context` now has permissions to fetch and create pods

```commandline
kubectl --context=restricteduser-context auth can-i get pods
```

```commandline
kubectl --context=restricteduser-context auth can-i create pods
```

* Step 11: Run a pod using `restricteduser-context`

```commandline
kubectl --context=restricteduser-context run --image nginx:alpine nginx
```

* Step 12: Using [`can-i`](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access), check to see if `restricteduser-context` user has permission to delete pods

```commandline
kubectl --context=restricteduser-context auth can-i delete pods
```

* Step 13: Using the restricteduser-context, try deleting the pod running

```commandline
kubectl --context=restricteduser-context get pods 
```
```commandline
kubectl --context=restricteduser-context delete pod <pod_name>
```

> **NOTE**: It will show the following Error: `Error from server (Forbidden): pods "nginx-xxxxxxxxxx-xxxxx" is forbidden: User "restricteduser" cannot delete pods in the namespace "restricted-namespace"`

#### *Teardown*:

* Step 1: To Remove the `Role`, `RoleBinding` and the `Pod`, delete the `restricted-namespace`. 

```commandline
kubectl delete ns restricted-namespace
```