# **Sysdig Falco**


### *Profiling and Monitoring K8s*

-------

#### Step 1:

* Navigate to the `SysdigFalco` directory on the provisioned server

```commandline
cd /root/container_training/Kubernetes/SysdigFalco
```

* Fetch the IP of the provisioned server

```commandline
serverip
```

-------

#### Step 2:

* On `line 21` in `falco_daemonset.yaml`, replace `<serverip>` and update the IP in curl command

```commandline
sed -i -e 's/SERVER-IP/<serverip>/g' falco_daemonset.yaml
```

**EXAMPLE**: `sed -i -e 's/SERVER-IP/104.1.1.1/g' falco_daemonset.yaml`


-------

#### Step 3:

* Create the Falco `daemonset` and wait for a few seconds till the pod is `Running`

```commandline
kubectl create -f falco_daemonset.yaml

kubectl get pods
```

* Create a pod that intentionally generates malicious events for Falco to track

```commandline
kubectl create -f falco-event-generator-deployment.yaml

kubectl get deployments

kubectl get pods
```

* Ensure that the `Status` of pods are `Running`

-------

#### Step 4:

* Start a server to get real-time logs of malicious events generated on the cluster. Observe the results

```commandline
./tornado_server.py
```

* Stop the server

```commandline
crtl + c
```

-------

#### Step 5:

* Stop the Malicious event-generator and Falco daemonset

```commandline
kubectl delete -f falco-event-generator-deployment.yaml -f falco_daemonset.yaml
```

---------

### Reading Material/References:


