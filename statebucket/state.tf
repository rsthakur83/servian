provider "aws" {
  region = "aws-region"
}


terraform {
  backend "s3" {
    bucket = "terraform_state_bucket"
    key    = "terraform.tfstate"
    region = "aws-region"
  }
}
