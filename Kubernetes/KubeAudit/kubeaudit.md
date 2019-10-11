## KubeAudit
---

#### **Lab Image : Kubernetes**

* Step 1: Navigate to the `KubeAudit` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/KubeAudit
```

* Step 2: Install [KubeAudit](https://github.com/Shopify/kubeaudit)

```commandline
wget https://github.com/Shopify/kubeaudit/releases/download/v0.5.2/kubeaudit_0.5.2_linux_amd64.tar.gz
```
```commandline
tar -xvzf kubeaudit_0.5.2_linux_amd64.tar.gz
```
```commandline
mv kubeaudit /usr/local/bin/
```

* Step 3: Check that every resource has a CPU and Memory limit

```commandline
kubeaudit limits
```

* Step 4: Check if namespace(s) have a default deny network policy 

```commandline
kubeaudit np
```

* Step 5: Check if default Service Account token is mounted

```commandline
kubeaudit sat
```

* Step 6: Check if readOnlyRootFilesystem is set to false

```commandline
kubeaudit rootfs
```

* Step 7: Checks if RunAsNonRoot has not been set

```commandline
kubeaudit nonroot
```

* Step 8: Run All Audits(`resources`, `network policies`, `Service Accounts`, `capabilities`, `privileged`, `allowPrivilegeEscalation`, `runAsNonRoot`, `readOnlyRootFilesystem` )

```commandline
kubeaudit all
```

> **NOTE**: Audits can be run on a particular namespace(`kubeaudit all -n default`) and the results can be fetched in `json` format(`kubeaudit all --json`)

* Step 9: Check the `insecure_vulflask_deployment.yaml`

```commandline
cat insecure_vulflask_deployment.yaml
```

* Step 10: Run `AutoFix` on the insecure_deployment and observe the changes

```commandline
kubeaudit autofix -f insecure_vulflask_deployment.yaml
```
```commandline
cat insecure_vulflask_deployment.yaml
```

> **NOTE**: The changes made can sometimes be too secure for the service to work

