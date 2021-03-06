# Union Mount

### **Lab Image : `Containers`**

---

* Step 1: Navigate to the Union Mount directory

```commandline
cd /root/container-training/Container/Union-Mount/
```

* Step 2: Create Three directories, sub-directories and files

```commandline
mkdir Folder-1 Folder-2 mnt
```
```commandline
mkdir -p Folder-1/Dir1 Folder-2/Dir1 Folder-2/Dir2
```
```commandline
touch Folder-1/File1.txt Folder-1/Dir1/dir1.txt Folder-1/Dir1/one.txt
```
```commandline
touch Folder-2/Dir1/file2.txt Folder-2/Dir1/two.txt Folder-2/Dir2/dir2_file.txt Folder-2/File2.txt
```

* Step 3: Check the structure of directories that have been created

```commandline
tree .
```

* Step 4: Mount the directories and files in `Folder-1` and `Folder-2` to `mnt`

```commandline
unionfs-fuse -o dirs=Folder-1:Folder-2  mnt/
```

* Step 5: Check the structure of `mnt/`

```commandline
tree mnt
```

---

## Teardown

* Step 6: Unmount the mount that was created

```commandline
umount -l mnt
```

* Step 7: Remove the directories, sub-directories and files created

```commandline
rm -rf Folder-1 Folder-2 mnt
```

---

### Reading Material/References:

* https://lwn.net/Articles/312641/

* https://www.thegeekstuff.com/2013/05/linux-aufs/