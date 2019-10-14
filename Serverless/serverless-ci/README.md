# Serverless CI/CD


* Step 1: Register/Login to [gitlab](https://gitlab.com)

* Step 2: Create a new project on GitLab. Under `Import Project`, select the `Repo by URL` option. 

* Step 3: Fill `https://github.com/we45/serverless-ci.git` as the `Git repository URL`, specify a project name and create the project

* Step 4: Once the repository has been imported, all files should be visible in the project.

* Step 5: Under `CI/CD` in `settings` of the project created, click on `Variables`.

* Step 6: Create a new variables with `ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` as the keys and paste their respective values. Ensure that the Variable is `Protected` and `Masked`


* Step 7: `.gitlab-ci.yml` is the file that is configured to do the following:

    * Run `bandit`(python SAST) on the application source code

    * Run `safety`(python SCA) to check for vulnerable python libraries

    * Deploy Serverless function using [`chalice`](https://github.com/aws/chalice)

    * Run scan on deployed functions using [`LambdaGuard`](https://github.com/Skyscanner/LambdaGuard)

* Step 8: Select `CI/CD`. Create and Run the pipeline

* Step 9: Wait for the pipeline to execute and observe the results

* Step 10: Login to AWS management console on the browser and verify if the Lambda function has been deployed successfully.
