#!/bin/bash
sudo apt-get update
sudo apt-get install golang git awscli wget unzip -y

sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo wget https://raw.githubusercontent.com/rsthakur83/servian/circleci-project-setup/CloudWatchAgentConfig.json
sudo dpkg -i amazon-cloudwatch-agent.deb
sudo cp CloudWatchAgentConfig.json /etc/cloudwatch_agent.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/etc/cloudwatch_agent.json -s


# dbuser=`aws ssm get-parameter     --name "dbusername"     --with-decryption --region aws-region --output text --query Parameter.Value`
# dbpassword=`aws ssm get-parameter     --name "dbpassword"     --with-decryption --region aws-region --output text --query Parameter.Value`
# dbname=`aws ssm get-parameter     --name "dbname"     --with-decryption --region aws-region --output text --query Parameter.Value`
# dbhostname=`aws ssm get-parameter     --name "dbhostname"     --with-decryption --region aws-region --output text --query Parameter.Value`


export VTT_DBUSER=`aws ssm get-parameter     --name "dbusername" --with-decryption --region aws-region --output text --query Parameter.Value`
export VTT_DBPASSWORD=`aws ssm get-parameter --name "dbpassword" --with-decryption --region aws-region --output text --query Parameter.Value`
export VTT_DBNAME=`aws ssm get-parameter     --name "dbname"     --with-decryption --region aws-region --output text --query Parameter.Value`
export VTT_DBHOST=`aws ssm get-parameter     --name "dbhostname" --with-decryption --region aws-region --output text --query Parameter.Value`
export VTT_LISTENHOST=`ec2metadata --local-ipv4`
export VTT_DBPORT=5432
export VTT_LISTENPORT=3000

#privip=`ec2metadata --local-ipv4`


#cd TechChallengeApp/;sudo ./build.sh;cd dist;
sudo git clone app-repo
cd TechChallengeApp/
export RELEASE_NUMBER="$(cat cmd/root.go |grep Version|awk '{print $2}'|cut -d '"' -f2)"
cd ..
aws s3 cp  s3://app_artifact_bucket/v${RELEASE_NUMBER}.zip .
sudo unzip v${RELEASE_NUMBER}.zip
cd dist

# sudo sed -i "s/postgres/$dbuser/g" conf.toml
# sudo sed -i "s/changeme/$dbpassword/g" conf.toml
# sudo sed -i "s/app/$dbname/g" conf.toml
# sudo sed -i '0,/localhost/s//'''$dbhostname'''/' conf.toml
# sudo sed -i '0,/localhost/s//'''$privip'''/' conf.toml

./TechChallengeApp updatedb -s;./TechChallengeApp serve
