terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}


provider "aws" {
  region = var.aws_region
}
resource "aws_s3_bucket" "tf-state" {
  bucket = "cloud-ctf-tf-state"
}
