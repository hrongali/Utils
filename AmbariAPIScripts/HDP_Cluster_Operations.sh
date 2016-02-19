#?
#!/bin/bash
 
AMBARI_ADMIN_PASSWORD=admin
RM_SERVER=<FQDN OF Resource Manager>
AMBARI_SERVER=<FQDN OF Ambari Server Host>
CLUSTER_NAME=<Cluster Name from Ambari GUI>
 
 
function wait(){
 
finished=0
 
while [ $finished -ne 1 ]
 
do
        str=$(curl -s -u admin:$AMBARI_ADMIN_PASSWORD http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/$1)
        if [[ $str == *"$2"* ]] || [[ $str == *"Service not found"* ]]
        then
                finished=1
        fi
        sleep 3
	echo $1 " Starting..."
done
 
}
 
 
 
function stop_services() {
        echo "STOPPING INDIVIDUAL SERVICES..."
        for service in $services; do
                echo $service
        done
	
	echo "STOPPING HDFS Service..." 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop HDFS via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HDFS
        wait "HDFS" "INSTALLED"
	echo "HDFS Stopped..."
 
 	echo "STOPPING MAPREDUCE2 Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop MAPREDUCE2 via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/MAPREDUCE2
        wait "MAPREDUCE2" "INSTALLED"
	echo "MAPREDUCE2 Stopped..."
 
	echo "STOPPING YARN Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop YARN via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/YARN
        wait "YARN" "INSTALLED"
	echo "YARN Stopped..."
 
	echo "STOPPING HIVE Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop HIVE via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HIVE
        wait "HIVE" "INSTALLED"
	echo "HIVE Stopped..."
 
	echo "STOPPING NAGIOS Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop NAGIOS via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/NAGIOS
        wait "NAGIOS" "INSTALLED"
	echo "NAGIOS Stopped..."
 
	echo "STOPPING GANGLIA Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop GANGLIA via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/GANGLIA
        wait "GANGLIA" "INSTALLED"
	echo "GANGLIA Stopped..."
 
	echo "STOPPING OOZIE Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop OOZIE via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/OOZIE
       wait "OOZIE" "INSTALLED"
	echo "OOZIE Stopped..."
 
        echo "STOPPING FLUME Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop FLUME via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/FLUME
        wait "FLUME" "INSTALLED"
	echo "FLUME Stopped..."
 
        echo "STOPPING ZOOKEEPER Service..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop ZOOKEEPER via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/ZOOKEEPER
        wait "ZOOKEEPER" "INSTALLED"
	echo "ZOOKEEPER Stopped..."
 
 
 
}
 
 
function start_services() {
        echo "STARTING INDIVIDUAL SERVICES..."
	echo "Starting ZOOKEEPER...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start ZOOKEEPER via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/ZOOKEEPER
        wait "ZOOKEEPER" "STARTED"
 
        echo "Starting HDFS...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HDFS via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HDFS
        wait "HDFS" "STARTED"
 
        echo "Starting MAPREDUCE2...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start MAPREDUCE2 via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/MAPREDUCE2
        wait "MAPREDUCE2" "STARTED"
 
        echo "Starting YARN...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start YARN via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/YARN
        wait "YARN" "STARTED"
 
        echo "Starting HIVE...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HIVE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HIVE
        wait "HIVE" "STARTED"
 
        echo "Starting OOZIE...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start OOZIE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/OOZIE
        wait "OOZIE" "STARTED"
 
        echo "Starting NAGIOS...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start NAGIOS via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/NAGIOS
        wait "NAGIOS" "STARTED"
 
        echo "Starting GANGLIA...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start GANGLIA via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/GANGLIA
        wait "GANGLIA" "STARTED"
 
        echo "Starting FLUME...."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start FLUME via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/FLUME
        wait "FLUME" "STARTED"
 
 
 
 
}
 
RUNNING_APPS=`GET http://$RM_SERVER:8088/ws/v1/cluster/appstatistics?states=running | cut -d, -f 3 | cut -d: -f 2 | sed s/}]}}//g`
echo "Number of Running Applications are : " $RUNNING_APPS
services=`curl -u admin:$AMBARI_ADMIN_PASSWORD -X GET http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services | grep service_name | cut -d: -f 2 | sed s/\"//g`
echo $services
OPTIONS="STOP START"
echo "Choose STOP/START HDP Services Using Ambari REST API"
select opt in $OPTIONS; do
   if [ "$opt" = "STOP" ]; then
      if [ $RUNNING_APPS == 0 ]; then
                stop_services services
      else
                echo "Please make sure all the Running applications are eitther completed or gracefully killed before Stopping alll Services..."
      fi
      exit
   elif [ "$opt" = "START" ]; then
      start_services services
      exit
   else
      echo bad option
      exit
   fi
done
