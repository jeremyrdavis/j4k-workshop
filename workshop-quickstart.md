# j4k workshop OpenShift deployment 
The instructions will allow you yo  deploy quarkus cafe coffee shop application on multiple user projects in RHPDS 

## Requirements 
* OpenShift target cluster
* OPenShift Cli 
* Ansible  


**cd into scripts folder**
```
cd scripts
```
**run script**
```
./configure_mutiple_users.sh 10 cluster-XxX-1234.cluster-XxX-1234.sandbox000.opentlc.com ocp_token
```


## Customization 
Edit line 48 to change target project if needed  
*Example*
```
    project_namespace: user$i-project
```