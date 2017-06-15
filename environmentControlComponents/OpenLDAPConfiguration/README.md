# OpenLDAP Server - Client configuration

[Follow this documentation for OpenLDAP setup](https://www.server-world.info/en/note?os=CentOS_7&p=openldap&f=1)

### Install OpenLDAP Server
On LDAP Server node:

```
yum -y install openldap-servers openldap-clients
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap. /var/lib/ldap/DB_CONFIG

[root@x1 ~]# service slapd start
Starting slapd:                                            [  OK  ]

[root@x1 ~]# chkconfig slapd on
```

### Set OPENLDAP Admin Password

on LDAP Server node node:

```
# Generate encrypted password

[root@x1 ~]# slappasswd
New password:
Re-enter new password:
{SSHA}xxxxxxxxxxx/xxxxxxxxxxxxxxxx

[root@x1 ~]# cd ~
[root@x1 ~]# mkdir work
[root@x1 ~]# cd work/
[root@x1 work]# mkdir openldap
[root@x1 work]# cd openldap/
[root@x1 openldap]# vi chrootpw.ldif
# specify the password generated above for "olcRootPW" section
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}xxxxxxxxxxxxxxxxxxxxxxxx

[root@x1 openldap]# ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={0}config,cn=config"

```

### Import basic schemas

```
[root@x1 openldap]# ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=cosine,cn=schema,cn=config"
ldap_add: Other (e.g., implementation specific) error (80)
	additional info: olcAttributeTypes: Duplicate attributeType: "0.9.2342.19200300.100.1.2"
  
 ---> If you get errors like above, it is most likely that the schemas are already included by default. You can ignore and proceed.

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif 

--> Same with the above two too.

```

### Set domain name in LDAP DB

```
[root@x1 openldap]# vi chdomain.ldif
# replace to your own domain name for "dc=***,dc=***" section
# specify the password generated above for "olcRootPW" section
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
  read by dn.base="cn=Manager,dc=hdp,dc=com" read by * none

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=hdp,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=Manager,dc=hdp,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}dc2Jpi+G4YIobacd3TIRrJ02mbOOY6Ws

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by
  dn="cn=Manager,dc=hdp,dc=com" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=Manager,dc=hdp,dc=com" write by * read


[root@x1 openldap]# ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif
If the above command results in an error like below:
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}monitor,cn=config"

modifying entry "olcDatabase={2}hdb,cn=config"
ldap_modify: No such object (32)
	matched DN: cn=config


Then, check the back end database using the below command:
[root@x1 openldap]# ldapsearch -H ldapi:// -Y EXTERNAL -b "cn=config" -LLL -Q "olcDatabase=*" dn
dn: olcDatabase={-1}frontend,cn=config

dn: olcDatabase={0}config,cn=config

dn: olcDatabase={1}monitor,cn=config

dn: olcDatabase={2}bdb,cn=config

Here it is bdb instead of hdb. Sp make changes to the chdomain.ldif file and try re running the below command:

[root@x1 openldap]# ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={1}monitor,cn=config"

modifying entry "olcDatabase={2}bdb,cn=config"

modifying entry "olcDatabase={2}bdb,cn=config"

modifying entry "olcDatabase={2}bdb,cn=config"

modifying entry "olcDatabase={2}bdb,cn=config"




[root@x1 openldap]# vi basedomain.ldif
# replace to your own domain name for "dc=***,dc=***" section
dn: dc=hdp,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: hdp com
dc: hdp

dn: cn=Manager,dc=hdp,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=hdp,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=hdp,dc=com
objectClass: organizationalUnit
ou: Group



[root@x1 openldap]# ldapadd -x -D cn=Manager,dc=hdp,dc=com -W -f basedomain.ldif
Enter LDAP Password:
adding new entry "dc=hdp,dc=com"

adding new entry "cn=Manager,dc=hdp,dc=com"

adding new entry "ou=People,dc=hdp,dc=com"

adding new entry "ou=Group,dc=hdp,dc=com"

```

### Firewall changes
```
Make changes to the the iptables. Add rule for port 389 before any REJECT rules
[root@x1 openldap]# vi /etc/sysconfig/iptables

# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p udp -m state --state NEW --dport 53 -j ACCEPT
-A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -p tcp --dport 389 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
~

[root@x1 openldap]# iptables --flush

```


### Add a user to LDAP
```
# generate encrypted password
[root@x1 openldap]# slappasswd
New password:
Re-enter new password:
{SSHA}xxxxxxxxxxxxxxxxx

[root@x1 openldap]# vi ldapuser.ldif

# create new
# replace to your own domain name for "dc=***,dc=***" section
dn: uid=hdpuser,ou=People,dc=hdp,dc=com
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: Hdpuser
sn: Linux
userPassword: {SSHA}xxxxxxxxxxxxxxxxxxxxxxxxxxx
loginShell: /bin/bash
uidNumber: 1000
gidNumber: 1000
homeDirectory: /home/hdpuser

dn: cn=hdpuser,ou=Group,dc=hdp,dc=com
objectClass: posixGroup
cn: Hdpuser
gidNumber: 1000
memberUid: hdpuser
```

### Setting up LDAP clients. On all boxes
```
[root@www ~]# yum -y install openldap-clients nss-pam-ldapd
```
[Equivalent Ansible playbook is ](https://github.com/hrongali/Utils/blob/master/environmentControlComponents/ansible_work/playbooks/setupclient.yml)


