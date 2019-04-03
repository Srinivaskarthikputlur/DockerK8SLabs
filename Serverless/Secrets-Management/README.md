# **Secrets Management**


### *  *

-------

#### Step 1:

* Navigate to the `ops` directory within `Secrets-Management` on the provisioned server

```commandline
cd /root/container_training/Serverless/Secrets-Management/ops
```

* Ensure that the AWS credentials have been configured

```commandline
aws configure
```

* Install `pip3`, if it is not installed already

```commandline
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py
```

* Install `Chalice`

```commandline
pip3 install chalice
```

-------

#### Step 2:

* Install `Terraform`

```commandline
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip &&
unzip terraform_0.11.13_linux_amd64.zip &&
mv terraform /usr/local/bin/ &&
rm terraform_0.11.13_linux_amd64.zip &&
terraform --version
```

* Install the dependencies

```commandline
terraform init

terraform apply
```

### *Note: Select `us-west-2` when terraform prompts. Other regions are ok to. Please use a valid region*


* If terraform has run successfully, it generates a `config.json`

```commandline
ls
```

-------

#### Step 3:

* Navigate to the `training-secrets` directory within `Secrets-Management` on the provisioned server

```commandline
cd /root/container_training/Serverless/Secrets-Management/training-secrets
```

* Create a `chalice` directory and copy the `config.json` that was generated in **Step 2**

```commandline
mkdir -p .chalice

cp ../ops/config.json .chalice/
```

* Install the requirements

```commandline
pip3 install -r requirements.txt

pip3 install chalice
```

-------

#### Step 4:

* Deploy the serverless function and wait for it to return the URL generated

```commandline
chalice deploy
```

* Test the generated endpoint

```commandline
http POST https://<api-generated-url>/api/create-user email=<some-email>
```

-------

### Reading Material/References:
