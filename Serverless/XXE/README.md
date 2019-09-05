# **XXE - Event Injection**

---

### **Lab Image : `Serverless`**

---

> **Note:** If you have not setup your aws cli follow [AWS-CLI-Configuration](../aws-configure/README.md) under the `Setup` section*

#### Step 1:

* Navigate to the `XXE` directory on the provisioned server

```commandline
cd /root/labs/Serverless-Workshop/XXE
```

* Install the necessary requirements

```commandline
sls plugin install -n serverless-python-requirements
```

---

#### Step 2:

* Take a look at the contents of the `serverless.yml` [here](https://github.com/we45/Serverless-Workshop/blob/master/XXE/serverless.yml)

```commandline
cat serverless.yml
```

---

#### Step 3:

* Deploy the function and wait for the deployment to complete.

```commandline
sls deploy
```

* Once the deployment is complete, an API endpoint(s) is displayed.

---

#### Step 4:

* Verify if a `S3` bucket was created

```commandline
aws s3 ls | grep we45-sls-xxe-
```

* Copy the malicious `Pass.docx` file to the `S3` bucket that was created.

```commandline
aws s3 cp Pass.docx s3://<name-of-your-s3-bucket>/Pass.docx
```

* Once the file has been copied to the `S3` bucket, check the logs of the function

```commandline
sls logs --function xxe
```

> **NOTE**: You should see the `/etc/passwd` file of the Lambda VM being dumped on screen

---

#### *Teardown*:

* On the provisioned server, navigate to `XXE` directory.

```commandline
cd /root/labs/Serverless-Workshop/XXE
```

* On the browser, access AWS Console. Select `S3` and delete the bucket that was created.

* Remove the serverless function that was deployed

```commandline
sls remove --force
```
