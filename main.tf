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

# ZMIEŃ TO na unikalną nazwę
variable "bucket_name" {
  type    = string
  default = "cloud-ctf-change-me-123456"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "lab" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Project = "cloud-ctf"
    Env     = "sandbox"
  }
}
