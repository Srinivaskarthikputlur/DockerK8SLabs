# **KAMUS**

---

> #### An open source, git-ops, zero-trust secret encryption and decryption solution for Kubernetes applications

### **Lab Image : Kubernetes**

---

#### Step 1:

* Navigate to the `Kamus` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/Kamus
```

* Setup [Helm](https://helm.sh/) and install Kamus on the server

```commandline
./helm_setup.sh
```

```commandline
helm upgrade --install kamus soluto/kamus
```

---

#### Step 2:

* Verify that the Kamus Services and Pods are `Running`

```commandline
kubectl get svc
```

```commandline
kubectl get pods
```

---

#### Step 3:

* Generate a Database name as a Kamus Secret

```commandline
kubectl run -it --rm --restart=Never kamus-cli --image=soluto/kamus-cli -- encrypt --secret user_db --service-account kamus --namespace default --kamus-url http://kamus-encryptor --allow-insecure-url
```
> **NOTE**: It will return an encrypted cipher

* In `mysql.yaml`, replace the `database_name` with the encrypted cipher returned in the previous step

```commandline
sed -i -e 's/database_name/<encrypted-cipher>/g' mysql.yaml
```

* Similarly, generate a Database password as a Kamus Secret

```commandline
kubectl run -it --rm --restart=Never kamus-cli --image=soluto/kamus-cli -- encrypt --secret Str0ngP@55w0rd --service-account kamus --namespace default --kamus-url http://kamus-encryptor --allow-insecure-url
```
> **NOTE**: It will return an encrypted cipher

* In `mysql.yaml`, replace the `database_password` with the encrypted cipher returned in the previous step

```commandline
sed -i -e 's/database_password/<encrypted-cipher>/g' mysql.yaml
```

---

#### Step 4:

* Create the mysql deployment and service

```commandline
kubectl apply -f mysql.yaml
```

* Verify if the pod(s) are `Running`

```commandline
kubectl get pods
```

* Exec into the pod to verify the secret

```commandline
kubectl exec -it <mysql-pod-name> bash
```

---

#### Step 5:

* Run the mysql command and enter the password that was set in **Step 3**

```commandline
mysql -u root -p
```
> **NOTE**: You will be prompted to enter password. Type `Str0ngP@55w0rd` and you will be provided a mysql shell.

---

#### *Teardown*:

* Exit the Shell and the container

```commandline
exit
```

```commandline
exit
```

* Delete the mysql deployment and service

```commandline
kubectl delete -f mysql.yaml
```

---
