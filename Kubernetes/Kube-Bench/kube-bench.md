## KubeBench
---

#### **Lab Image : Kubernetes**

* Step 1: Navigate to the `Kube-Bench` directory on the provisioned server

```commandline
cd /root/container-training/Kubernetes/Kube-Bench
```

* Step 2: Fetch the list of available commands and options

```commandline
./kube-bench --help
```

* Step 3: Run the `Kube-bench` scan on the k8s cluster

```commandline
./kube-bench master
```

* Step 4: Save results as a `.json` file

```commandline
./kube-bench --json master > report.json
```
```commandline
cat report.json
```
