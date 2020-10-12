#!/bin/bash 

set -x 

oc new-project j4k-etherpad --display-name "J4k Etherpad"

oc new-app --template=postgresql-persistent --param POSTGRESQL_USER=ether --param POSTGRESQL_PASSWORD=ether --param POSTGRESQL_DATABASE=etherpad --param POSTGRESQL_VERSION=10 --param VOLUME_CAPACITY=10Gi --labels=app=etherpad_db

sleep 15

# From Github Repo
oc new-app -f https://raw.githubusercontent.com/wkulhanek/docker-openshift-etherpad/master/etherpad-template.yaml -p DB_TYPE=postgres -p DB_HOST=postgresql -p DB_PORT=5432 -p DB_DATABASE=etherpad -p DB_USER=ether -p DB_PASS=ether -p ETHERPAD_IMAGE=quay.io/wkulhanek/etherpad:1.8.4 -p ADMIN_PASSWORD=secret