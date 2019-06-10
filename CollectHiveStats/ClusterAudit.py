import requests
import json
import sys
import time
from requests_kerberos import HTTPKerberosAuth, OPTIONAL

### ChangeME
AMBARI_DOMAIN =  'abc'

CLUSTER_NAME = "<CLUSTER NAME FROM AMBARI>"
STACK_VERSION="2.5.0.0"

outputDirName='<OUTPUT DIRECTORY NAME>'

#AMBARI_DOMAIN = raw_input('Enter the fully qualified Domain Name for Ambari Server: ')
AMBARI_DOMAIN = '<Your ambari server FQDN>'
#AMBARI_PORT = raw_input('    Enter the Ambari Port: (8080)')
AMBARI_PORT = '8443'

TIMELINE_SERVER='<Your timeline server FQDN>'
TIMELINE_PORT='8188'


#AMBARI_USER_ID=raw_input('    Ambari Admin User id:')
AMBARI_USER_ID='AMBARI USER NAME'
#AMBARI_USER_PW=raw_input('    Ambari Admin Password:')
AMBARI_USER_PW='AMBARI USER PASSWORD'
print("  ")
#RM_DOMAIN = raw_input('Enter the fully qualified Domain Name for the YARN ResourceManager:')
RM_DOMAIN = '<YOUR RESOURCE MANAGER FQDN>'
#RM_PORT = raw_input('   Enter the ResourceManager WebUI port (8088):')
RM_PORT = '8088'
if (AMBARI_DOMAIN == '') : AMBARI_DOMAIN = 'server1.hdp'
if (AMBARI_USER_ID == '') : AMBARI_USER_ID = 'admin'
if (AMBARI_USER_PW == '') : AMBARI_USER_PW = 'admin'
if (AMBARI_PORT == '') : AMBARI_PORT = '8080'
if (RM_DOMAIN == '') : RM_DOMAIN = 'server2.hdp'
if (RM_PORT == '') : RM_PORT = '8088'
#RM_DOMAIN = '127.0.0.1'
CLUSTER_NAME = ""
STACK_VERSION=""

### End of changeme


# yarn.resourcemanager.webapp.address
STACK="HDP"

RM_PORT = '8088'
CLUSTER_VERSION = ""

def ambariREST( restAPI ) :
## TODO Verify received code = 200 or else produce an error
    url = "https://"+AMBARI_DOMAIN+":"+AMBARI_PORT+restAPI
    r= requests.get(url, auth=(AMBARI_USER_ID, AMBARI_USER_PW), verify=False)
    return(json.loads(r.text));

#def rmREST( restAPI ) :
#    url = "http://"+RM_DOMAIN+":"+RM_PORT+restAPI
#    print ("Hello#1")
#    r=requests.get(url,auth=HTTPKerberosAuth())
#    print ("Hello#2")
#    print r.status_code
#    print r.text
#    return(json.loads(r.text));

def timelineREST( restAPI) :
    url = "http://"+TIMELINE_SERVER+":"+TIMELINE_PORT+restAPI
    r=requests.get(url,auth=HTTPKerberosAuth())
    return(json.loads(r.text));
print "A"	


def getClusterVersionAndName() :
    json_data = ambariREST("/api/v1/clusters")
    cname = json_data["items"][0]["Clusters"]["cluster_name"]
    cversion =json_data["items"][0]["Clusters"]["version"]
    return cname, cversion, json_data;

def getClusterRepository() :
    restAPI = "/api/v1/stacks/"+STACK+"/versions/"+STACK_VERSION+"/operating_systems/redhat7/repositories/"+CLUSTER_VERSION
    json_data = ambariREST(restAPI)
    return json_data;

def getAmbariHosts() :
    restAPI = "/api/v1/hosts"
    json_data =  ambariREST(restAPI)
    return(json_data);


def rmREST(restAPI) :
    url = "http://"+RM_DOMAIN+":"+RM_PORT+restAPI
    kerberos_auth=HTTPKerberosAuth(mutual_authentication=OPTIONAL)
    r=requests.get(url,auth=kerberos_auth)
    return(json.loads(r.text));

def getResourceManagerInfo() :
    restAPI = "/ws/v1/cluster/info"
    json_data =  rmREST(restAPI)
    return(json_data);

def getResourceManagerMetrics() :
    restAPI = "/ws/v1/cluster/metrics"
    json_data =  rmREST(restAPI)
    return(json_data);

def getRMschedulerInfo() :
    restAPI = "/ws/v1/cluster/scheduler"
    json_data =  rmREST(restAPI)
    return(json_data);

def getAppsSummary() :
    restAPI = "/ws/v1/cluster/apps"
    json_data =  rmREST(restAPI)
    return(json_data); 

# lookinto looping through app detail and node attempts
def getNodesSummary() :
    ## TODO find out why this is not working
    restAPI = "/ws/v1/cluster/nodes"
    json_data =  rmREST(restAPI)
    return(json_data); 
   
def getConfigGroups() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/config_groups"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getServiceConfigTypes() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/configurations"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getServiceActualConfigurations() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME
    json_data =  ambariREST(restAPI)
    return(json_data); 


def getCheckClusterForRollingUpgrades() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/rolling_upgrades_check/"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getStackVersions() :
    restAPI = "/api/v1/clusters/"+CLUSTER_NAME+"/stack_versions/"
    json_data =  ambariREST(restAPI)
    return(json_data); 

def getTimelineVertices() :
	restAPI = "/ws/v1/timeline/TEZ_VERTEX_ID"
	json_data = timelineREST(restAPI)
	return(json_data);
	
def getTimelineDAGs() :
	restAPI = "/ws/v1/timeline/TEZ_DAG_ID"
	json_data = timelineREST(restAPI)
	return(json_data);
	

##############################################
### Beginning of Maine Execution
##############################################
data = [ {'ClusterAudit' : 'v1.2' } ]

CLUSTER_NAME, CLUSTER_VERSION,clusterInfo = getClusterVersionAndName()
STACK_VERSION = CLUSTER_VERSION.split('-')[1]
data.append({'ClusterInfo' : clusterInfo})
data.append({'Configurations' : getServiceActualConfigurations()})

data.append({'ClusterRepo' : getClusterRepository()})
data.append({'AmbariAvailableHosts' : getAmbariHosts()})
data.append({'ResourceManagerInfo' : getResourceManagerInfo()})
data.append({'SchedulerInfo' : getRMschedulerInfo()})
data.append({'AppsSummary' : getAppsSummary()})
data.append({'NodeSummary' : getNodesSummary()})
data.append({'ConfigGroups' : getServiceConfigTypes()})
data.append({'ResourceManagerMetrics' : getResourceManagerMetrics()})
data.append({'DAG Details' : getTimelineDAGs() } )
data.append({'Vertices' : getTimelineVertices() } )
print "A"

#data.append({'RollingCheckValidation' : getCheckClusterForRollingUpgrades()})

a = json.dumps(data, sort_keys=True, indent=2, separators=(',', ': '))

timestr=time.strftime("%Y%m%d-%H%M%S")
outputFileName = outputDirName+CLUSTER_NAME+"-ClusterAudit"+"-"+timestr+".json"
outputFile = open(outputFileName,"w")
outputFile.write(a)
outputFile.close()
msg = "Please email the file "+outputFileName+" to <email address>."
print (msg)

# curl -v -X GET  http://127.0.0.1:8088/ws/v1/cluster/apps | python -m json.tool

