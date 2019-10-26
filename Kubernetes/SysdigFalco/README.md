# Sysdig Falco
---

> #### Profiling and Monitoring K8s*

### **Lab Image : Kubernetes**

---

* Step 1: Navigate to the `SysdigFalco` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/SysdigFalco
```

* Step 2: Fetch the IP of the provisioned server

```commandline
serverip
```

* Step 3: On `line 21` in `falco_daemonset.yaml`, replace `<serverip>` and update the IP in curl command

```commandline
sed -i -e 's/SERVER-IP/'"$(serverip)"'/g' falco_daemonset.yaml
```

**EXAMPLE**: `sed -i -e 's/SERVER-IP/104.1.1.1/g' falco_daemonset.yaml`

* Step 4: Create the Falco `daemonset` and wait for a few seconds till the pod is `Running`

```commandline
kubectl create -f falco_daemonset.yaml
```
```commandline
kubectl get pods
```

* Step 5: Create a pod that intentionally generates malicious events for Falco to track

```commandline
kubectl create -f falco-event-generator-deployment.yaml
```
```commandline
kubectl get deployments
```
```commandline
kubectl get pods
```

* Step 6: Ensure that the `Status` of pods are `Running`

* Step 7: Start a server to get real-time logs of malicious events generated on the cluster. Observe the results

```commandline
python3 tornado_server.py
```


---

## Teardown

* Step 8: Stop the server with `ctrl` + `c`

* Step 9: Stop the Malicious event-generator and Falco daemonset

```commandline
kubectl delete -f falco-event-generator-deployment.yaml -f falco_daemonset.yaml
```
