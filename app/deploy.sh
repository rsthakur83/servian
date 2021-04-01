#!/bin/bash

lcfg1="APP-LC"
lcfg2="APP-LC-2"
asg="APP-ASG"
#lc=`aws autoscaling describe-launch-configurations --region us-east-1|grep LaunchConfigurationName|awk '{print $2}'|cut -d '"' -f2`
lc=`aws autoscaling describe-launch-configurations --region us-east-1|grep LaunchConfigurationName|awk '{print $2}'|tail -1|cut -d '"' -f2`

if [[ "$lc" == "$lcfg1" ]]
then

	vpc=`aws ec2 describe-vpcs --filters Name=tag:Name,Values='WP Solution VPC' --query 'Vpcs[*].VpcId' --output text`
	sg=`aws ec2  describe-security-groups --filter Name=vpc-id,Values=$vpc  Name=group-name,Values=app_asg --region us-east-1 --query 'SecurityGroups[*].[GroupId]' --output text`
	aws autoscaling create-launch-configuration --launch-configuration-name $lcfg2 --key-name serkey --image-id ami-042e8287309f5df03 --instance-type t2.micro --iam-instance-profile  cwdb_iam_profile --security-groups $sg  --user-data file://userdata.sh
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg2 --min-size 4 --max-size 4
	sleep 150
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg2 --min-size 2 --max-size 2
	sleep 60
	aws autoscaling delete-launch-configuration --launch-configuration-name $lcfg1 


elif [[ "$lc" == "$lcfg2" ]]
then

	vpc=`aws ec2 describe-vpcs --filters Name=tag:Name,Values='WP Solution VPC' --query 'Vpcs[*].VpcId' --output text`
	sg=`aws ec2  describe-security-groups --filter Name=vpc-id,Values=$vpc  Name=group-name,Values=app_asg --region us-east-1 --query 'SecurityGroups[*].[GroupId]' --output text`
	aws autoscaling create-launch-configuration --launch-configuration-name $lcfg1 --key-name serkey --image-id ami-042e8287309f5df03 --instance-type t2.micro --iam-instance-profile  cwdb_iam_profile --security-groups $sg  --user-data file://userdata.sh
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg1 1 --min-size 4 --max-size 4
	sleep 150	
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg1 --min-size 2 --max-size 2
	sleep 60
	aws autoscaling delete-launch-configuration --launch-configuration-name $lcfg2 
	
else
        cd app
	terraform init
	terraform plan
	terraform apply --auto-approve  
fi
