# SetupKerberos Instructions

on all hosts:

yum install ntp -y

service ntpd start

chkconfig ntpd on



On the m1.hdp.com host:



yum install krb5-server krb5-libs krb5-workstation

Edit the krb5.conf with the settings below for the HDP.COM realm

vi /etc/krb5.conf

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 default_realm = HDP.COM
 dns_lookup_realm = false
 dns_lookup_kdc = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true

[realms]
 HDP.COM = {
  kdc = m1.hdp.com
  admin_server = m1.hdp.com
 }

[domain_realm]
 .hdp.com = HDP.COM
 hdp.com = HDP.COM
 
 
 
If the entropy is not enough, the below process will help setting up the entropy:

yum install wget
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release*rpm
yum install haveged
haveged -w 1024
echo "/usr/local/sbin/haveged -w 1024" >> /etc/rc.local

Check the entropy:

[root@m1 ~]# cat /proc/sys/kernel/random/entropy_avail
2500

Install thre KDC
kdb5_util create -s
(pwd  0s)

Start the KDC and KADMIN:
/etc/rc.d/init.d/krb5kdc start
/etc/rc.d/init.d/kadmin start

Start these on server start up:
chkconfig krb5kdc on
chkconfig kadmin on

Create an admin principal:
kadmin.local -q "addprinc admin/admin"
(usual pwd with 0s)

Make sure the admin principal has access:
vi /var/kerberos/krb5kdc/kadm5.acl
*/admin@HDP.COM *

Restart the kadmin:
/etc/rc.d/init.d/kadmin restart


Installing Kerberos clients:

on all other hosts:
yum -y install krb5-workstation

Copy the krb5.conf from m1.hdp.com to the m2 and m3 hosts
from m1.hdp.com

scp /etc/krb5.conf root@m2:/etc/krb5.conf
scp /etc/krb5.conf root@m3:/etc/krb5.conf

