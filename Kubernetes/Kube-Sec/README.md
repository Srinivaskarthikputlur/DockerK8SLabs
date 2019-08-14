# **KubeSec**

---

> #### Kubesec helps quantify risk for K8s resources based on the suggested best-practices

#### **Lab Image : Kubernetes**

---

#### Step 1:

* Navigate to the `KubeHunter` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/Kube-Sec
```

---

#### Step 2:

* Analyze the K8s YAML spec `insecure_vulflask_deployment.yaml`

```commandline
./kubesec insecure_vulflask_deployment.yaml

```

* Save results to a `.json` file

```commandline
./kubesec insecure_vulflask_deployment.yaml >> kubesec_result.json
```

---

### Reading Material/References:
