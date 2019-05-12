# **Kubernetes CI/CD**


### *CI/CD to run security scans and deploy to a k8s cluster using GitLab CI*

-------

#### Step 1:

* Register/Login to [gitlab](https://gitlab.com)

* Create a new project on GitLab. Under `Import Project`, select the `Repo by URL` option. 

* Fill `https://github.com/we45/Vulnerable-Flask-App.git` as the `Git repository URL`, specify a project name and create the project

* Once the repository has been imported, all files should be visible in the project.

-------

#### Step 2:

* To deploy on the k8s cluster, gitlab will need a `service account`. Encode(base64) and Copy the existing kubernetes config file that's on the provisioned server.

```bash
cat ~/.kube/config | base64

# Copy the base64 value
```

### *Ideally, you'd create a separate `service-account` for deployment with RBAC and limited permissions*

* Under `CI/CD` in `settings` of the project created, click on `Variables`.

* Create a new variable with `K8s_SECRET_CONFIG_FILE` as the key and paste the `base64` value copied in **Step 2**. Ensure that the Variable is `Protected`

-------

#### Step 3:

* Clone the GitLab project on the provisioned server(or your machine).

* Copy `.gitlab-ci.yml`, `staging-namespace.yml` and `vul_flask-deployment.yml` to the project directory. Commit and push the changes to the Git repo

```bash
# Make sure that the necessary files mentioned above have been copied
git status

git add -A

git commit -m 'Testing K8s CI/CD'

git push
```

-------

#### Step 4:

* `.gitlab-ci.yml` is the file that is configured to do the following:

    * Run `bandit`(python SAST) on the application source code
    
    * Run `safety`(python SCA) to check for vulnerable python libraries
    
    * Build the docker image
    
    * Run `Clair` scan on the docker image
    
    * Run `kubesec` on the k8s deployment spec file
    
    * Deploy to the k8s cluster that's running on the provisioned server

* Select `CI/CD`. Create and Run the pipeline

* Wait for the pipeline to execute and observe the results

---------

#### Step 5:

* On the provisioned server, check if the deployment was successful

```bash
kubectl get ns

kubectl -n staging get deployments

kubectl -n staging get pods
```

* Stop the pods running on the `staging` namespace by deleting it

```bash
kubectl delete ns staging
```

---------

### Reading Material/References:

