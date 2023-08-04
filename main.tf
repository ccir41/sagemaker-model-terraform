terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "sagemaker-endpoint-deploy-tf-state"
    key     = "sagemaker-deploy/terraform.tfstate"
    region  = "ap-south-1"
    profile = "sagemaker"
  }

  required_version = ">= 1.5.4"
}

data "aws_caller_identity" "current" {}

locals {
  prefix         = "${var.prefix}-${var.infra_env}"
  aws_account_id = data.aws_caller_identity.current.account_id
  common_tags = {
    Environment = var.infra_env
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}
