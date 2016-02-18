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

```
Number of Running Applications are :  0
AMBARI_METRICS FLUME HBASE HDFS HIVE MAPREDUCE2 OOZIE PIG SPARK SQOOP TEZ YARN ZOOKEEPER
Choose STOP/START HDP Services Using Ambari REST API
1) STOP
2) START
#?
```

Option#1 Will Stop all the services one after one

Option#2 Will Start all the services one after one
