# KubeSeal - Shared Secrets

### **Lab Image : Kubernetes**

---

* Step 1: Navigate to the `SealedSecrets` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/SealedSecrets
```

* Step 2: Create a `SealedSecret` controller and Custom Resource Definition

```commandline
kubectl create -f controller.yaml
```
```commandline
kubectl create -f sealedsecret-crd.yaml
```
```commandline
kubectl get pods -n kube-system
```

* Step 3: Seal the existing secret(`mysecret.json`) with `kubeseal`

```commandline
kubeseal <mysecret.json >mysealedsecret.json
```

* Step 4: Check the Sealed secret file

```commandline
cat mysealedsecret.json
```

* Step 5: Create the `Sealed Secret` and check the created secret

```commandline
kubectl create -f mysealedsecret.json
```
```commandline
kubectl get secrets
```

## Teardown

* Step 1: Delete the created sealed secret, controller and the custom resource definition

```commandline
kubectl delete -f mysealedsecret.json -f controller.yaml -f sealedsecret-crd.yaml
```
