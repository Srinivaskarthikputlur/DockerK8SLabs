# **OSQuery**

---

> #### Monitoring Docker Security with OSQuery

### **Lab Image : `Containers`**

---

#### Step 1:

* Launch a few containers with insecure configurations

> ##### Container Running in 'Privileged' Mode

```commandline
docker run -d --privileged nginx:latest
```

> ##### Container Running with Sensitive Environment Variables and Sensitive Volumes exposed

```commandline
docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw  -v /etc:/hostFS -d mysql:latest
```

* Start the OSQuery Interactive interface

```commandline
osqueryi
```

---

#### Step 2:

* Query for all containers running with the `--privileged` flag

```sql
SELECT name, image, status from docker_containers where privileged=1;
```

* Query for all containers with `Sensitive` environment variables

```sql
select name,env_variables FROM docker_containers where env_variables LIKE "%PASSWORD%";
```

* Query for containers with Dangerous Volume mounts

```sql
select id, source, destination from docker_container_mounts where source LIKE "%etc%";
```

* Query for containers running without `security_opts`

```sql
SELECT name, image, state
```
```sql
FROM docker_containers
```
```sql
WHERE security_options NOT LIKE "%apparmor%";
```

* Query for users with access to docker daemon

```sql
SELECT u.username
```
```sql
FROM user_groups ug
```
```sql
LEFT JOIN users u ON u.uid=ug.uid
```
```sql
WHERE ug.gid IN (SELECT gid FROM groups WHERE groupname="docker");
```

* Query for Memory limits and usage for all containers

```sql
select ds.name, ds.memory_usage, ds.memory_limit from docker_container_stats ds, docker_containers dc where dc.id=ds.id;
```

* Exit from the OSQuery Interactive interface with `ctrl` + `c`

---

#### *Teardown*:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://osquery.readthedocs.io/en/stable/

* https://github.com/facebook/osquery

* https://blog.rapid7.com/2016/05/09/introduction-to-osquery-for-threat-detection-dfir/

