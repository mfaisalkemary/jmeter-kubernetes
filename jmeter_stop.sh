#!/bin/bash
#Script writtent to stop a running jmeter master test
#This will stop the process on the master and also kill the jmeter slave pods
#The slave pods will be created automatically
#Kindly ensure you have the necessary kubeconfig

working_dir=`pwd`

#Get namesapce variable
tenant=`awk '{print $NF}' $working_dir/tenant_export`

master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`

kubectl -n $tenant exec -ti $master_pod bash /jmeter/apache-jmeter-3.3/bin/stoptest.sh

for i in `kubectl -n $tenant get pods | grep jmeter-slaves | awk '{print $1}'`
do
kubectl -n $tenant delete pod $i
done

kubectl -n $tenant get po | grep jmeter-slaves