# **Serverless CI/CD**


### *CI/CD to run security scans, deploy function(s) to AWS Lambda and run scans on the deployed function(s)*

-------

#### Step 1:

* Register/Login to [gitlab](https://gitlab.com)

* Create a new project on GitLab. Under `Import Project`, select the `Repo by URL` option. 

* Fill `https://github.com/we45/serverless-ci.git` as the `Git repository URL`, specify a project name and create the project

* Once the repository has been imported, all files should be visible in the project.

-------

#### Step 2:

* Under `CI/CD` in `settings` of the project created, click on `Variables`.

* Create a new variables with `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` as the keys and paste their respective values. Ensure that the Variable is `Protected` and `Masked`

-------

#### Step 3:

* `.gitlab-ci.yml` is the file that is configured to do the following:

    * Run `bandit`(python SAST) on the application source code
    
    * Run `safety`(python SCA) to check for vulnerable python libraries
    
    * Deploy Serverless function using [`chalice`](https://github.com/aws/chalice)
    
    * Run scan on deployed functions using [`LambdaGuard`](https://github.com/Skyscanner/LambdaGuard)

* Select `CI/CD`. Create and Run the pipeline

* Wait for the pipeline to execute and observe the results

---------

#### Step 4:

* Login to AWS management console on the browser and verify if the Lambda function has been deployed successfully.

---------

### Reading Material/References:
