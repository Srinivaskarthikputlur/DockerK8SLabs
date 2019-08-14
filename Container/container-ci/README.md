# **CI for Container Security**

---

> #### CI to run security scans using GitLab*

---

#### Step 1:

* Register/Login to [gitlab](https://gitlab.com)

* Create a new project on GitLab. Under `Import Project`, select the `Repo by URL` option. 

* Fill `https://github.com/we45/container-ci.git` as the `Git repository URL`, specify a project name and create the project

* Once the repository has been imported, all files should be visible in the project.

---

#### Step 2:

* `.gitlab-ci.yml` is the file that is configured to build the docker image and run specified scans.

* Select `CI/CD`. Create and Run the pipeline

* Wait for the pipeline to execute and observe the results

---

### Reading Material/References:
