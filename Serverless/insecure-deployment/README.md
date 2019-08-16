# **Insecure Deployment**

---

### **Lab Image : `Serverless`**

---

#### Step 1:

* Navigate to `Insecure Deployment` directory on the provisioned server

```commandline
cd container-training/Serverless/insecure-deployment
```

---

#### Step 2:

* Ensure that the AWS credentials have been configured

```commandline
aws configure
```

* Deploy the Serverless function using `arc`

```commandline
npx deploy
```

* On the browser, login to AWS console and look at the deployed function in `lambda`

---