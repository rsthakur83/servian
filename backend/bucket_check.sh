#!/bin/sh


bucket1=`aws s3api list-buckets --query "Buckets[].Name" --output text |grep -E app_artifact_bucket  |awk '{print $1}'`
bucket2=`aws s3api list-buckets --query "Buckets[].Name" --output text |grep -E terraform_state_bucket |awk '{print $2}'`

if [[  $bucket1 = "terraform_state_bucket" || $bucket2 = "app_artifact_bucket" && ( $bucket2 = "terraform_state_bucket" || $bucket1 = "app_artifact_bucket" ) ]];then
        echo "Bucket Exist"
else
        echo "Bucket Doest Not Exist Creating!!!!!"
        ../terraform init
        ../terraform plan
        ../terraform apply --auto-approve
fi
