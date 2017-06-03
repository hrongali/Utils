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

