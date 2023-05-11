terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-test"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock-table"
  }
}

provider "aws" {
  region = "eu-west-2"
}

# Create the DynamoDB table for locking the Terraform state file
resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name           = "terraform-state-lock-table"
  hash_key       = "LockID"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}