## Kubernetes CI/CD
---

#### **Lab Image : Kubernetes**


* Step 1: Register/Login to [gitlab](https://gitlab.com)

* Step 2: Create a `New project` on GitLab. 

  * Under `Import Project`, select the `Repo by URL` option.

* Step 3: Fill `https://github.com/we45/kubernetes-ci.git` as the `Git repository URL`.
  
  * Specify a project name and create the project

```commandline
https://github.com/we45/kubernetes-ci.git
```

* Step 4: Once the repository has been imported, all files should be visible in the project.

* Step 5: `.gitlab-ci.yml` is the file that is configured to do the following:
  * Run `bandit`(python SAST) on the application source code
  * Run `safety`(python SCA) to check for vulnerable python libraries
  * Build the docker image
  * Run `Clair` scan on the docker image
  * Run `kubesec` on the k8s deployment spec file
  * Deploy to the k8s cluster that's running on the provisioned server
  
* Step 6: To deploy on the k8s cluster, gitlab will need a `service account`. Encode(base64) and Copy the existing kubernetes config file that's on the provisioned server.

```commandline
cat /root/.kube/config | base64
```

> **NOTE**: Ideally, you'd create a separate `service-account` for deployment with RBAC and limited permissions

* Step 7: On the sidebar of the project, click on `Settings`

  * Click on `CI/CD`
  * `Expand` the `Variables` option

* Step 8: Create new variables

  * `K8s_SECRET_CONFIG_FILE` as the key and paste the value fetched in **Step 5**
  * Ensure that the Variable is `Protected`
  * Save the variables

* Step 9: On the sidebar of the project, click on `CI/CD`

* Step 10: Click on `Run Pipeline` and wait for the pipeline to execute.

* Step 11: On the provisioned server, check if the deployment was successful

```commandline
kubectl get ns
```
```commandline
kubectl -n staging get deployments
```
```commandline
kubectl -n staging get pods
```

* Step 12: Stop the pods running on the `staging` namespace by deleting it

```commandline
kubectl delete ns staging
```
