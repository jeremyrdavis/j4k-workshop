#!/bin/bash 
set -xe

if [ "$#" -ne 3 ];
then 
  echo "Please ener numner for users"
  echo "Usage: $0 10 ocp4.example.com ocp_token"
  exit 1
fi 

if ! $(oc whoami &>/dev/null); then
 printf "%s\n" "###############################################################################"
 printf "%s\n" "#  MAKE SURE YOU ARE LOGGED IN TO AN OPENSHIFT CLUSTER:                       #"
 printf "%s\n" "#  $ oc login https://your-openshift-cluster:8443                             #"
 printf "%s\n" "###############################################################################"
 exit 1
fi

export DOMAIN=$2
export OCP_TOKEN=$3

if [ ! -d  ~/.ansible/roles/tosin2013.quarkus_cafe_demo_role/ ];
then 
  ansible-galaxy install tosin2013.quarkus_cafe_demo_role
fi 
#https://github.com/tosin2013/quarkus-cafe-demo-role.git

for ((i = 1 ; i <= ${1} ; i++)); do
  echo "User: $i"
  echo "user$i"
 
cat >deploy-quarkus-cafe.yml<<YAML
- hosts: localhost
  become: yes
  vars:
    deployment_method: docker
    openshift_token: ${OCP_TOKEN}
    openshift_url: https://api.${DOMAIN}:6443
    use_kubeconfig: false
    insecure_skip_tls_verify: true
    default_owner: root
    default_group: root
    version_barista: 2.7.0
    version_core: 2.7.0
    version_customermocker: 2.7.0
    version_kitchen: 2.7.0
    version_web: 2.8.1
    project_namespace: user$i-project
    delete_deployment: false
    skip_amq_install: false
    skip_quarkus_cafe_barista: false
    skip_quarkus_cafe_core: false
    skip_quarkus_cafe_kitchen: false
    skip_quarkus_cafe_web: false
    skip_quarkus_cafe_customermock: false
    domain: ${DOMAIN}
  roles:
    - tosin2013.quarkus_cafe_demo_role
YAML
cat deploy-quarkus-cafe.yml
sleep 10s
ansible-playbook  deploy-quarkus-cafe.yml -vv
rm -rf deploy-quarkus-cafe.yml
done