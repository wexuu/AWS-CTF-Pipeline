terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "cloud-ctf-tf-state"
    region  = "eu-central-1"
    encrypt = true
  }
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}


provider "aws" {
  region = var.aws_region
}
