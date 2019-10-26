# Pod Security Policy

> #### There are multiple options that one can use to protect the runtime deployment of a Pod. One of them is the `PodSecurityPolicy`.

> #### `PodSecurityPolicy` can be deployed, cluster-wide, namespace-wide or inline as part of the Pod's declaration.

> #### We are going to use a combination of `AppArmor` profiles, `Seccomp` and some good container security practices to protect our deployment

### **Lab Image : Kubernetes**

---

* Step 1: Navigate to the `PodSecurityPolicy` directory on the provisioned server.

```commandline
cd /root/container-training/Kubernetes/PodSecurityPolicy
```


* Step 2: Read the `secure-ngflask-deploy.yml` file and observe the changes

```yaml
annotations:
    seccomp.security.alpha.kubernetes.io/defaultProfileName:  'docker/default'
    container.apparmor.security.beta.kubernetes.io/secure-vul-flask: 'localhost/k8s-vul-flask-redis-armor'
```

    * These annotations essentially ensure two things: *
    
    1. The default docker `seccomp` profile is added to the the Pod
    
    2. A custom AppArmor Profile that we have prepped for this class, will be applied against a specific container in this case, the flask application.


* Step 3: Read the AppArmor profile

```commandline
cat k8s-vul-flask-redis-armor
```

> #### The objective of this profile is not necessarily to block all possible attacks (which is highly difficult/impossible to achieve).

> #### The focus is to block off some possible attacks and reduce the damage caused by a compromise of the app or container in any way.


* Step 4: Apply the AppArmor profile on the local instance

```commandline
apparmor_parser k8s-vul-flask-redis-armor
```

* Step 5: Create a nginx `configmap`

```commandline
kubectl create configmap nginx-config --from-file=/root/container-training/Kubernetes/PodSecurityPolicy/reverseproxy.conf
```

* Step 6: Deploy the Secure nginx-flask pod and wait the the status of the pod is `Running`

```commandline
kubectl create -f secure-ngflask-deploy.yml
```
```commandline
kubectl get pods
```

* Step 7: Exec into the container running flask to get a shell environment

```commandline
kubectl exec -it secure-ngflask-redis --container secure-vul-flask -- sh
```

* Step 8: Try to create and access files. Observe the results

```commandline
touch shell.py
```
```commandline
touch /tmp/shell.py
```
```commandline
cat /etc/passwd
```
```commandline
cat /etc/shadow
```

## Teardown

* Step 1: Delete the pods

```commandline
kubectl delete -f secure-ngflask-deploy.yml
```
