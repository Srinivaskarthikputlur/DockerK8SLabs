# **Kubernetes CI/CD**

---

> #### CI/CD to run security scans and deploy to a k8s cluster using GitLab CI

### **Lab Image : Kubernetes**

---

#### Step 1:

* Register/Login to [gitlab](https://gitlab.com)

* Create a new project on GitLab. Under `Import Project`, select the `Repo by URL` option. 

* Fill `https://github.com/we45/kubernetes-ci.git` as the `Git repository URL`.

```commandline
https://github.com/we45/kubernetes-ci.git
```

* Once the repository has been imported, all files should be visible in the project.

---

#### Step 2:

* `.gitlab-ci.yml` is the file that is configured to do the following:
  * Run `bandit`(python SAST) on the application source code
  * Run `safety`(python SCA) to check for vulnerable python libraries
  * Build the docker image
  * Run `Clair` scan on the docker image
  * Run `kubesec` on the k8s deployment spec file
  * Deploy to the k8s cluster that's running on the provisioned server


* To deploy on the k8s cluster, gitlab will need a `service account`. Encode(base64) and Copy the existing kubernetes config file that's on the provisioned server.

```commandline
cat ~/.kube/config | base64
```

> **NOTE**: Ideally, you'd create a separate `service-account` for deployment with RBAC and limited permissions

*  On the sidebar of the project, click on `Settings` and then select `CI/CD`. `Expand` the `Variables` option

* Create a new variable with `K8s_SECRET_CONFIG_FILE` as the key and paste the `base64` value copied in the previous step. Ensure that the Variable is `Protected`

---

#### Step 3:

* On the sidebar of the project, click on `CI/CD`. `Run pipeline` and wait for the pipeline to execute.

---

#### Step 4:

* On the provisioned server, check if the deployment was successful

```commandline
kubectl get ns
```
```commandline
kubectl -n staging get deployments
```
```commandline
kubectl -n staging get pods
```

---

#### *Teardown*:

* Stop the pods running on the `staging` namespace by deleting it

```commandline
kubectl delete ns staging
```

---

### Reading Material/References:

