# **Deploying a Serverless Function**


### *  *

-------

#### Step 1:

* Navigate to `Insecure Deserialization` project in the `DVFaaS` directory on the provisioned server

```commandline
cd /root/DVFaaS-Damn-Vulnerable-Functions-as-a-Service/insecure_deserialization/insecure-deserialization
```

-------

#### Step 2:

* Install `pip3`, if it is not installed already

```commandline
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py
```

* Install `Chalice`

```commandline
pip3 install chalice
```

-------

#### Step 3:

* Set the necessary environment variables

```commandline
export LC_ALL=C.UTF-8

export LANG=C.UTF-8
```

* Ensure that the AWS credentials have been configured

```commandline
aws configure
```

-------

#### Step 3:

* Deploy the Serverless function using `chalice`

```commandline
chalice deploy
```

* On the browser, login to AWS console and look at the deployed function in `lambda`

-------

#### Step 4:

* Delete the serverless function

```commandline
chalice delete
```

---------

### Reading Material/References:
