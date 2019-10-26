# Prometheus + Grafana

> #### Monitoring a K8s cluster with Prometheus + Grafana

### **Lab Image : Kubernetes**

---

* Step 1: Navigate to the `Prometheus-Grafana` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/Prometheus-Grafana
```

* Step 2: Create a K8s namespace

```commandline
kubectl create namespace monitoring
```
```commandline
kubectl get ns
```

* Step 3: Create `ClusterRole`, `ConfigMap`, Prometheus `Service` and `Deployment`

```commandline
kubectl create -f clusterRole.yaml -f config-map.yaml -f prometheus.yaml
```
```commandline
kubectl get configmap -n monitoring
```
```commandline
kubectl get deployments -n monitoring
```
```commandline
kubectl get svc -n monitoring
```
```commandline
kubectl get pods -n monitoring
```

* Step 4: Launch grafana and create a service

```commandline
kubectl create -f grafana-prometheus.yaml
```
```commandline
kubectl get deployments -n monitoring
```
```commandline
kubectl get svc -n monitoring
```

* Step 5: Launch a few pods on the k8s cluster to monitor

```commandline
kubectl create -f wecare-k8.yaml
```

* Step 6: Get URLs of `Prometheus` and `Grafana` Services

```commandline
kubectl -n monitoring get svc
```

> #### The output should be similar to:

```commandline
NAME                 TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
grafana              NodePort   10.109.181.65    <none>        3000:32310/TCP   25m
prometheus-service   NodePort   10.101.242.178   <none>        8080:31000/TCP   26m
```

* Step 7: Make note of the `CLUSTER-IP` and `PORT(S)` of both services

* Step 8: Setup `proxy-forward` to be able to access grafana UI from the browser.

```commandline
kubectl -n monitoring port-forward svc/grafana --address=0.0.0.0 3000
```

* Step 9: Fetch the IP of the provisioned server

```commandline
serverip
```

* Step 10: Access Grafana on the browser using `IP:3000` and login using the credentials, `admin/admin`.

* Step 11: Clicking on `Add data source`, should redirect to a new page. Select `Prometheus` as the Type from the drop down Menu and fill the prometheus URL found in **Step 4**. `Save and Test` to add Data source once the Form is filled

* Step 12: On the Dashboard Tab on the Left, click on `Manage`. 

* Step 13: Click on the Upload button to upload `kubernetes-pod-monitoring.json` file and click on Load. The contents of `kubernetes-pod-monitoring.json` can also be pasted as an alternative to upload

* Step 14: Select the configured source as the Prometheus data source and import

* Step 15: Dashboard with resource usage statistics should show up. It is possible to select Namespace and Pod from the drop down as well.

---

## Teardown

* On the server provisioned, stop all the pods and services running by deleting the `monitoring` namespace

```commandline
kubectl delete ns monitoring
```
