# LambdaGuard

**Note:** If you have not setup your aws cli follow [AWS-CLI-Configuration](aws-configure/README.md) under the `Setup` section*

* Step 1: In your image, navigate over to `/root/labs/Serverless-Workshop/`

```commandline
cd /root/labs/Serverless-Workshop/
```

* Step 2: Run lambdaguard against a region where serverless functions have been deployed

```commandline
lambdaguard --region=us-west-2
```

* Step 3: View the report by running a simple webserver

```commandline
python -m http.server
```

* Step 4: Access the lab in a new tab, run the following command and access the URL returned

```commandline
echo http://$(serverip):8000/report.html
```

### Teardown

* Step 5: In the previous tab, run `ctrl` + `c` to stop the **http server**
