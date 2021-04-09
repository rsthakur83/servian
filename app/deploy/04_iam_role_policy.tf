## IAM profile for instance
resource "aws_iam_instance_profile" "cwdb_iam_profile" {
  name = "cwdb_iam_profile"
  role = aws_iam_role.cwdbrole.name
}

# IAM role 
resource "aws_iam_role" "cwdbrole" {
  name = "cwdbrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "IAM Role for App"
  }
}

# IAM policy 
resource "aws_iam_policy" "policy" {
  name = "cwdbrole_policy"
  description = "A cloudwatch & ssm parameter"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        },
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:*:*:parameter/*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::app_artifact_bucket/*"
        }
    ]
}

EOF
tags = {
 Name = "Custom Policy for App"
}

}

# IAM policy attachement to IAM role (cwdbrole)
resource "aws_iam_role_policy_attachment" "cw_db_policy_attach" {
  role       = aws_iam_role.cwdbrole.name
  policy_arn = aws_iam_policy.policy.arn
}
