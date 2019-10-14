# Bandit


* Step 1: Navigate to the directory on the provisioned server that has the project to be scanned

```commandline
cd /root/
```

* Step 2: Run Bandit on the `DvFaaS` Project and observe the results

```commandline
bandit -r -f json DVFaaS-Damn-Vulnerable-Functions-as-a-Service/
```

* Step 3: Generate a `.json` report

```commandline
bandit -r -f json -o bandit_result.json DVFaaS-Damn-Vulnerable-Functions-as-a-Service/
```

