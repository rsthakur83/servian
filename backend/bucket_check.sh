#!/bin/sh



if [[  ( bucket1 = "terraform_state_bucket" && bucket2 = "app_artifact_bucket" ) || ( bucket2 = "terraform_state_bucket" || bucket1 = "app_artifact_bucket" )  ]];then
        echo "Bucket Exist"
else
        echo "Bucket Doest Not Exist Creating!!!!!"
        ../terraform init
        ../terraform plan
        ../terraform apply --auto-approve
fi
