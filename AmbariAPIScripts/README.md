# Ambari API Utility to Stop and Start HDP Services
This is a utility to Stop and Start HDP Services using Ambari API

The Script needs three parameters which can be edited inside the script
```
AMBARI_ADMIN_PASSWORD=<Admin password for Ambari Admin account>
AMBARI_SERVER=<Ambari server host FQDN>
CLUSTER_NAME=<Cluster name. FOund in Ambari GUI>
```
Note: If the admin user id is different than "admin", make necessary changes in the curl commands. Should be generic change across all the commands

# Running the Script:
```
./HDP_Cluster_Operations.sh
```
