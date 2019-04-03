# **KubeAudit**


### *Audit K8s cluster against common security controls*

-------

#### Step 1:

* Navigate to the `KubeAudit` directory on the provisioned server.

```commandline
cd /root/container_training/Kubernetes/KubeAudit
```

-------

#### Step 2:

* Install [KubeAudit](https://github.com/Shopify/kubeaudit)

```commandline
wget https://github.com/Shopify/kubeaudit/releases/download/v0.5.2/kubeaudit_0.5.2_linux_amd64.tar.gz

tar -xvzf kubeaudit_0.5.2_linux_amd64.tar.gz

mv kubeaudit /usr/local/bin/
```

-------

#### Step 3:

* Check that every resource has a CPU and Memory limit

```commandline
kubeaudit limits
```

* Check if namespace(s) have a default deny network policy 

```commandline
kubeaudit np
```

* Check if default Service Account token is mounted

```commandline
kubeaudit sat
```

* Check if readOnlyRootFilesystem is set to false

```commandline
kubeaudit rootfs
```

* Checks if RunAsNonRoot has not been set

```commandline
kubeaudit nonroot
```

* Run All Audits(`resources`, `network policies`, `Service Accounts`, `capabilities`, `privileged`, `allowPrivilegeEscalation`, `runAsNonRoot`, `readOnlyRootFilesystem` )

```commandline
kubeaudit all
```

#####  **Audits can be run on a particular namespace(`kubeaudit all -n default`) and the results can be fetched in `json` format(`kubeaudit all --json`)**

-------

#### Step 4:

* Check the `insecure_vulflask_deployment.yaml`

```commandline
cat insecure_vulflask_deployment.yaml
```

* Run `AutoFix` on the insecure_deployment and observe the changes

```commandline
kubeaudit autofix -f insecure_vulflask_deployment.yaml
```

#####  **The changes made can sometimes be too secure for the service to work**

---------

### Reading Material/References:

