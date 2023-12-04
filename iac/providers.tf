terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-medium-api-notification"
    key    = "state"
    region = "eu-central-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
