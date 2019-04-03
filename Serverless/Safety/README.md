# **Safety**


### *Python Source-Code-Analysis-Tool*

-------

#### Step 1:

* Navigate to that has the `requirements` to be scanned on the provisioned server

```commandline
cd ~/serverless-training-apps
```

-------

#### Step 2:

* Create a python virtual-environment, activate it and install the requirements

```commandline
virtualenv venv

ls

source venv/bin/activate

pip install -r ~/serverless-training-apps/cv_uploader/cv-upload-handler/requirements.txt
```

-------

#### Step 3:

* Run a scan on the installed python libraries

```commandline
safety check

# Generate a json report
safety check --json
```

---------

### Reading Material/References:
