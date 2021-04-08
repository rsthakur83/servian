# Terraform S3 backend to store state file
terraform {
  backend "s3" {
    bucket = "terraform_state_bucket"
    key    = "terraform.tfstate"
    region = "aws-region"
  }
}
