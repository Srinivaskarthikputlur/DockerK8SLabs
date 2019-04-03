# **NodeJsScan**


### *NodeJS Static-Application-Security-Testing*

-------

#### Step 1:

* Navigate to the `NodeJsScan` directory on the provisioned server

```commandline
cd /root/NodeJsScan
```

-------

#### Step 2:

* Create a python virtual-environment, activate it and install the requirements

```commandline
virtualenv -p python2 venv

ls

source venv/bin/activate

pip install -r requirements.txt
```

-------

#### Step 3:

* Run a scan against a directory containing NodeJs code and generate a `.json` report

```commandline
python cli.py -r report -d /root/serverless-training-apps/jwt_example/
```

---------

### Reading Material/References:
