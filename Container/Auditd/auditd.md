# Auditd

>Docker access monitoring and accounting

### **Lab Image : Containers**

---

* Step 1: Check if the `auditd` service is running. If it's not, start the `auditd` service.

```commandline
service auditd status
```

```commandline
service auditd start
```

* Step 2: Create an audit rule to watch for `Read`, `Write`, `Execute` and `Attribute` changes on the `docker-daemon` logging them to a logfile and append `docker-daemon` label at end of each log-entry to make logs easier to query

```commandline
auditctl -w /usr/bin/docker -p rwxa -k docker-daemon
```

> **NOTE**: `auditctl` is for temporary use till system is shutdown. For a more permanent approach, add rule in rules.d/ and run `augenriles --check`.  If there's a difference, run `augenrules --load` to load the new rules


* Step 3: Create, Launch, Run and Stop a few containers for Auditd to log.

```commandline
docker run -d nginx:alpine
```

```commandline
docker run -d alpine:latest
```

```commandline
docker run -d -p 5050:5050 abhaybhargav/vul_flask
```

* Step 4: Search for logs

```commandline
ausearch -k docker-daemon
```

* Step 5: Fetch the count of executable events that are run.

```commandline
ausearch --start today --raw | aureport -x --summary
```

## Teardown:

* Step 6: Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://www.thegeekdiary.com/understanding-system-auditing-with-auditd/
