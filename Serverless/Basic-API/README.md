# **Basic Serverless API**

---

> #### This is a basic lesson in triggering serverless functions for API Gateway Events.

### **Lab Image : `Serverless`**

---

> **Note:** If you have not setup your aws cli follow [AWS-CLI-Configuration](../aws-configure/README.md) under the `Setup` section*

#### Step 1:

* Update the Serverless Lab repository on the provisioned server.

```commandline
cd /root/labs/Serverless-Workshop
```

```commandline
git pull
```

* Navigate to `Basic-API` directory.

```commandline
cd /root/labs/Serverless-Workshop/Basic-API
```

---

#### Step 2:

* Install the necessary requirements.

```commandline
sls plugin install -n serverless-python-requirements
```

---

#### Step 3:

* Take a look at the contents of the `serverless.yml` [here](https://github.com/we45/Serverless-Workshop/blob/master/Basic-API/serverless.yml).

```commandline
cat serverless.yml
```

---

#### Step 4:

* Deploy the function and wait for the deployment to complete.

```commandline
sls deploy
```

* Once the deployment is complete, an API endpoint is displayed.

---

#### Step 5:

* Now, invoke the function using the API endpoint that was returned in **STEP 4**: 

```commandline
http GET https://XXXXXXXX.execute-api.us-west-2.amazonaws.com/dev/hello
```

---

#### *Teardown*:

* On the provisioned server, navigate to `Basic-API` directory.

```commandline
cd /root/labs/Serverless-Workshop/Basic-API
```

* Remove the serverless function that was deployed

```commandline
sls remove --force
```
