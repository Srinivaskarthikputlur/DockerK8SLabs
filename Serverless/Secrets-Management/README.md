# Secrets Management


* Step 1: Navigate to the `ops` directory within `Secrets-Management` on the provisioned server

```commandline
cd /root/container-training/Serverless/Secrets-Management/ops
```

* Step 2: Ensure that the AWS credentials have been configured

```commandline
aws configure
```

* Step 3: Install `pip3`, if it is not installed already

```commandline
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py
```

* Step 4: Install `Chalice`

```commandline
pip3 install chalice
```

* Step 5: Install `Terraform`, if it's not installed already.

```commandline
wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip &&
unzip terraform_0.11.13_linux_amd64.zip &&
mv terraform /usr/local/bin/ &&
rm terraform_0.11.13_linux_amd64.zip &&
terraform --version
```

* Step 6:Install the dependencies

```commandline
terraform init
```
```commandline
terraform apply
```

> **Note:**  Select `us-west-2` when terraform prompts. Other regions are ok to. Please use a valid region

* Step 7: If terraform has run successfully, it generates a `config.json`

```commandline
ls
```

* Step 8: Navigate to the `training-secrets` directory within `Secrets-Management` on the provisioned server

```commandline
cd /root/container-training/Serverless/Secrets-Management/training-secrets
```

* Step 9: Create a `chalice` directory and copy the `config.json` that was generated in **Step 2**

```commandline
mkdir -p .chalice
```
```commandline
cp ../ops/config.json .chalice/
```

* Step 10: Install the requirements

```commandline
pip3 install -r requirements.txt
```
```commandline
pip3 install chalice
```

* Step 11: Deploy the serverless function and wait for it to return the URL generated

```commandline
chalice deploy
```

* Step 12: Test the generated endpoint

```commandline
http POST https://<api-generated-url>/api/create-user email=<some-email>
```
