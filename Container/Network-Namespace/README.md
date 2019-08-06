# **Network Namespace**

### * *

-------

#### Step 1:

* Get the list of network interfaces, iptables and network gateways on the machine.

```commandline
ifconfig -a
```
```commandline
iptables -L
```
```commandline
route -n
```


-------

#### Step 2:

* Add a Networking namespace and fetch the list of Network namespaces

```commandline
ip netns add NetNameSpace
```
```commandline
ip netns list
```

-------

#### Step 3:

* Exec into the Network namespace and run **Step 1** again. Observe the results

```commandline
sudo ip netns exec NetNameSpace bash
```
```commandline
ifconfig -a
```
```commandline
iptables -L
```
```commandline
route -n
```

-------

#### Step 4:

* Exit from the Network namespace

```commandline
exit
```

* Fetch the list of Network namespaces and delete the once created in **Step 2**

```commandline
ip netns list
```
```commandline
sudo ip netns del NetNameSpace
```

---------

### Reading Material/References:

