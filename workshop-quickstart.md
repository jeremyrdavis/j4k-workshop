# j4k workshop OpenShift deployment 
The instructions will allow you yo  deploy quarkus cafe coffee shop application on multiple user projects in RHPDS.

## Requirements 
* OpenShift target cluster
* OpenShift Cli 
* Ansible  
* RHPDS


**cd into scripts folder**
```
cd scripts
```

**run script**
```
./configure_mutiple_users.sh 10 cluster-XxX-1234.cluster-XxX-1234.sandbox000.opentlc.com ocp_token
```

**To delete deployment run**
```
./delete-deployments.sh 10 cluster-XxX-1234.cluster-XxX-1234.sandbox000.opentlc.com ocp_token
```