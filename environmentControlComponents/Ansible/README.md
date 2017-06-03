# Ansible installation on x1.hdp.com

The installation should be performed on x1 host

To install Ansible, we need EPEL package(Extra Packages for Enterprise Linux) which will not be available with default Linux Install.


### Install wget:

yum install wget -y

### Install instructions for EPEL 
````
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum install epel-release-6-8.noarch.rpm -y

yum repolist
````

#### You should see epel package in the repolist output:
````
[root@x1 ~]# yum search ansible
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.usf.edu
 * epel: epel.mirror.constant.com
 * extras: mirror.metrocast.net
 * updates: centos.blazar.mx
========================================================================================== N/S Matched: ansible ==========================================================================================
ansible-doc.noarch : Documentation for Ansible
ansible-inventory-grapher.noarch : Creates graphs representing ansible inventory
ansible-lint.noarch : Best practices checker for Ansible
python2-ansible-tower-cli.noarch : A CLI tool for Ansible Tower
ansible.noarch : SSH-based configuration management, deployment, and task execution system

  Name and summary matches only, use "search all" for everything.
````
 
 
 ## Install Ansible:
```
 yum install ansible -y
```

### Make a directory for ansible stuff

````
cd ~
mkdir ansible
cd ansible
````


## Passwordless SSH set up

````
[root@x1 ansible]# ssh-keygen -t rsa

---
---
Your identification has been saved in loginkey.
Your public key has been saved in loginkey.pub.
````

### On every host Distribute the public key (####.pub) from ansible host to the authorized_keys file of the ~/.ssh directory of the target host

````
cd ~/.ssh
touch authorized_keys
vi authorized_keys
Paste the public key in the file, quit and save
````

### Try logging to all the hosts from ansible host(x1) using the below command:

````
ssh -i loginkey root@m1
````

## Take a break here and Set up DNS. Resume after DNS is setup.
