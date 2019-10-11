## KubeSec
---

#### **Lab Image : Kubernetes**


* Step 1: Navigate to the `Kube-Sec` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/Kube-Sec
```

* Step 2: Analyze the K8s YAML spec `insecure_vulflask_deployment.yaml`

```commandline
./kubesec insecure_vulflask_deployment.yaml
```

* Step 3: Save results to a `.json` file

```commandline
./kubesec insecure_vulflask_deployment.yaml >> kubesec_result.json
```

