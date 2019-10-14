# NodeJsScan


* Step 1: Navigate to the `NodeJsScan` directory on the provisioned server

```commandline
cd /root/NodeJsScan
```

* Step 2: Create a python virtual-environment

```commandline
virtualenv -p python2 venv
```
```commandline
ls
```

* Step 3: Activate the virtual environment
```commandline
source venv/bin/activate
```

* Step 4: Install the requirements

```commandline
pip install -r requirements.txt
```

* Step 5: Run a scan against a directory containing NodeJs code and generate a `.json` report

```commandline
python cli.py -r report -d /root/serverless-training-apps/jwt_example/
```
