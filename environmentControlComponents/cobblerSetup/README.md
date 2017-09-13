# Cobbler set up
Cobbler helps in automating multiple server OS installs.

### Prerequisites
#### Disable selinux:

```
[root@x1 ~]# vi /etc/sysconfig/selinux
SELINUX=disabled
```

#### Set up Iptables to accept traffic from certain ports
```
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 69 -j ACCEPT
-A INPUT -m state --state NEW -m udp -p udp --dport 69 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 25151 -j ACCEPT

Save and close and restart iptables

[root@x1 ~]# service iptables restart
iptables: Setting chains to policy ACCEPT: filter          [  OK  ]
iptables: Flushing firewall rules:                         [  OK  ]
iptables: Unloading modules:                               [  OK  ]
iptables: Applying firewall rules:                         [  OK  ]
```

Make sure epel is installed

```
[root@x1 ansible]# rpm -qa | grep epel
epel-release-6-8.noarch

[root@x1 ~]# yum list installed | grep epel
ansible.noarch         2.3.0.0-3.el6    @epel
                                        @epel
epel-release.noarch    6-8              @/epel-release-6-8.noarch
                       2.6.1-2.el6      @epel
python-httplib2.noarch 0.7.7-1.el6      @epel
                       2.6-3.el6        @epel
python-keyczar.noarch  0.71c-1.el6      @epel
sshpass.x86_64         1.06-1.el6       @epel

```

#### Install Cobbler
We will use DHCP fom the router, so ignoring dhcp from the components that needs to be installed.

```
yum install cobbler cobbler-web dhcp debmirror pykickstart system-config-kickstart dhcp mod_python tftp cman dhcp -y

```

#### Enable TFTP and rsync
Change diable=yes to disable=no in /etc/xinetd.d/tftp


```
vi /etc/xinetd.d/tftp

# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
```

Change diable=yes to disable=no in /etc/xinetd.d/rsync

```
vi /etc/xinetd.d/rsync

# default: off
# description: The rsync server is a good addition to an ftp server, as it \
#       allows crc checksumming etc.
service rsync
{
        disable = no
        flags           = IPv6
        socket_type     = stream
        wait            = no
        user            = root
        server          = /usr/bin/rsync
        server_args     = --daemon
        log_on_failure  += USERID
}
```

#### Configure DHCP
```
cp /usr/share/doc/dhcp-4.1.1/dhcpd.conf.sample /etc/dhcp/dhcpd.conf

Take a back up of /etc/dhcp/dhcpd.conf file and replace the contents of the file with the below(next-server should have the cobbler server ip address):

option domain-name "hdp.com";
#specify DNS server ip and additional DNS server ip
option domain-name-servers 192.168.1.1;
#specify default lease time
default-lease-time 600;
#specify Max lease time
max-lease-time 7200;
#specify log method
log-facility local7;
#Configuring subnet and iprange
subnet 192.168.1.0 netmask 255.255.255.0 {
range 192.168.1.50 192.168.1.100;
option broadcast-address 192.168.1.255;
#Default gateway ip
option routers 192.168.1.1;
}
#Fixed ip address based on MAC id
host Printer01 {
hardware ethernet 02:34:37:24:c0:a5;
fixed-address 192.168.1.55;
}
allow booting;
allow bootp;
option option-128 code 128 = string;
option option-129 code 129 = text;
next-server 192.168.1.xxx;
filename "pxelinux.0";

```
Start all services:

```
[root@x1 ansible]# service httpd start
Starting httpd:
[root@x1 ansible]# service httpd status
httpd (pid  2850) is running...
[root@x1 ansible]# service dhcpd start
[root@x1 ansible]# service xinetd start
Starting xinetd:                                           [  OK  ]
[root@x1 ansible]# service xinetd status
xinetd (pid  2926) is running...
[root@x1 ansible]# service cobblerd start
Starting cobbler daemon:                                   [  OK  ]
[root@x1 ansible]# service cobblerd status
cobblerd (pid 2456) is running...
```

Make all the services start on reboot:
```
[root@x1 ansible]# chkconfig httpd on
[root@x1 ansible]# chkconfig dhcpd on
[root@x1 ansible]# chkconfig xinetd on
[root@x1 ansible]# chkconfig cobblerd on
```

#### Configure COBBLER
```
openssl passwd -1
Password:
Verifying - Password:
xxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Make changes in /etc/cobbler/settings file like below:
```
vi /etc/cobbler/settings

Find the default_password_crypted and replace the value with the above xxxxxxx value

Find the manage_dhcp: 0 and change it manage_dhcp: 1

Set your Cobbler’s IP address in “server” and “next_server” fields.

```

Make changes in /etc/cobbler/dhcp.template like below:
```
Change the  next-server value to the IP of the cobbler server
```
Make sure the values in /etc/cobbler/modules.conf are like below:

```
[authentication]
module = authn_configfile

[authorization]
module = authz_allowall

```
Setup the username and password for the cobbler web interface. To do that, run the following command. Input your preferred password twice.
```
[root@x1 ansible]# htdigest /etc/cobbler/users.digest "Cobbler" cobbler
Changing password for user cobbler in realm Cobbler
New password:
Re-type new password:
```
Here, my cobbler web interface user name is “cobbler”, and its password is “xxxxxx”.

Download the required network boot loaders using the following command.

```
cobbler get-loaders
```

If you get a login failed message, then try "service cobblerd restart" and then try the commnd again. You should see "TASK COMPLETE" message.


Make changes to /etc/debmirror.conf file like below:
```
Comment out

#@dists="sid";
#@arches="i386";
```
Finally, restart all services:
```
[root@x1 ansible]# service httpd restart
Stopping httpd:                                            [  OK  ]
Starting httpd:                                            [  OK  ]
[root@x1 ansible]# service xinetd restart
Stopping xinetd:                                           [  OK  ]
Starting xinetd:                                           [  OK  ]
[root@x1 ansible]# service dhcpd restart
[root@x1 ansible]# service cobblerd restart
Stopping cobbler daemon:                                   [  OK  ]
Starting cobbler daemon:                                   [  OK  ]
```

Do a cobbler check
```
cobbler check
```

Upon success, do a :
```
cobbler sync
```

### Import ISO file to cobbler server:

Make sure Centos 6.5 ISO file is present in /root directory
```
[root@x1 ~]# mount -o loop CentOS-6.8-x86_64-minimal.iso /mnt/

[root@x1 ~]# cobbler import --path=/mnt/ --name=CentOS_6.8
task started: 2017-06-25_225324_import
task started (id=Media import, time=Sun Jun 25 22:53:24 2017)
Found a candidate signature: breed=redhat, version=rhel6
Found a matching signature: breed=redhat, version=rhel6
Adding distros from path /var/www/cobbler/ks_mirror/CentOS_6.8:
creating new distro: CentOS_6.8-x86_64
trying symlink: /var/www/cobbler/ks_mirror/CentOS_6.8 -> /var/www/cobbler/links/CentOS_6.8-x86_64
creating new profile: CentOS_6.8-x86_64
associating repos
checking for rsync repo(s)
checking for rhn repo(s)
checking for yum repo(s)
starting descent into /var/www/cobbler/ks_mirror/CentOS_6.8 for CentOS_6.8-x86_64
processing repo at : /var/www/cobbler/ks_mirror/CentOS_6.8
directory /var/www/cobbler/ks_mirror/CentOS_6.8 is missing xml comps file, skipping
*** TASK COMPLETE ***

```

