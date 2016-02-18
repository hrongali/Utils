#?
#!/bin/bash
 
AMBARI_ADMIN_PASSWORD=admin
AMBARI_SERVER=had-master1
CLUSTER_NAME=SVCHDPPOC
RM_SERVER=had-master3 
 
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
done
 
}
 
 
 
function stop_services() {
        echo "STOPPING INDIVIDUAL SERVICES..."
        for service in $services; do
                echo $service
        done
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop HDFS via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HDFS
        wait "HDFS" "INSTALLED"
 
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop MAPREDUCE2 via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/MAPREDUCE2
        wait "MAPREDUCE2" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop YARN via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/YARN
        wait "YARN" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop HIVE via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HIVE
        wait "HIVE" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop NAGIOS via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/NAGIOS
        wait "NAGIOS" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop GANGLIA via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/GANGLIA
        wait "GANGLIA" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop OOZIE via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/OOZIE
       wait "OOZIE" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop FLUME via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/FLUME
        wait "FLUME" "INSTALLED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop ZOOKEEPER via REST"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/ZOOKEEPER
        wait "ZOOKEEPER" "INSTALLED"
 
 
 
}
 
 
function start_services() {
        echo "STARTING INDIVIDUAL SERVICES..."
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start ZOOKEEPER via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/ZOOKEEPER
        wait "ZOOKEEPER" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HDFS via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HDFS
        wait "HDFS" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start MAPREDUCE2 via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/MAPREDUCE2
        wait "MAPREDUCE2" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start YARN via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/YARN
        wait "YARN" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HIVE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/HIVE
        wait "HIVE" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start OOZIE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/OOZIE
        wait "OOZIE" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start NAGIOS via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/NAGIOS
        wait "NAGIOS" "STARTED"
 
        curl -u admin:$AMBARI_ADMIN_PASSWORD -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start GANGLIA via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://$AMBARI_SERVER:8080/api/v1/clusters/$CLUSTER_NAME/services/GANGLIA
        wait "GANGLIA" "STARTED"
 
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
      if [$RUNNING_APPS == 0 ]; then
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
