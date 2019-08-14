# **Resource Quota and Limits**

---

### **Lab Image : Kubernetes**

---

#### Step 1:

* Navigate to the `Resource Quota and Limits` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/ResourceQuota_Limit
```

---

#### Step 2:

* Check the `nginx-basic-limit.yaml` pod specification

* Create a pod on the `default` namespace

```commandline
kubectl create -f nginx-basic-limit.yaml
```

* Ensure that the `Status` of pod is set to `Running`

```commandline
kubectl get pods
```

---

#### Step 3:

* Test the memory consumption of the pod with the `stress` command.

```commandline
kubectl exec -it nginx-resource -- stress --cpu 1 --io 1 --vm 2 --vm-bytes 100M
```
> ###### Stop it after a few seconds with `ctrl` + `c`

```commandline
kubectl exec -it nginx-resource -- stress --cpu 1 --io 1 --vm 2 --vm-bytes 200M
```
> ###### Stop it after a few seconds with `ctrl` + `c`

```commandline
kubectl exec -it nginx-resource -- stress --cpu 1 --io 1 --vm 2 --vm-bytes 400M
```
> ###### Stop it after a few seconds with `ctrl` + `c`

* It can be observed that the stress test fails with **`exit code 1`** at 400M because of the limit specified in Pod Spec.

---

#### Step 4:

* Delete the pod

```commandline
kubectl delete -f nginx-basic-limit.yaml
```

---

### Reading Material/References:

