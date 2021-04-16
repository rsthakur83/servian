#!/bin/sh

aws s3api list-buckets --query "Buckets[].Name" --output text |grep -E "app_artifact_bucket";aws s3api list-buckets --query "Buckets[].Name" --output text |grep -E "terraform_state_bucket" 

if [ $? -eq 0 ]; then
        echo "Bucket Exist"
else
        echo "Bucket Doest Not Exist Creating!!!!!"
        ../terraform init
        ../terraform plan
        ../terraform apply --auto-approve
fi
