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
    key     = "cloud-ctf/terraform.tfstate"
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
resource "aws_vpc" "vpc-main" {
  cidr_block = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name    = "cloud-ctf-vpc"   # ← TO jest nazwa widoczna w konsoli
    Project = "cloud-ctf"
  }
}

resource "aws_subnet" "public"{
  vpc_id = aws_vpc.vpc-main.id
  cidr_block = "10.0.0.0/28"
    tags = {
    Name    = "cloud-ctf-subnet-public"   # ← TO jest nazwa widoczna w konsoli
    Project = "cloud-ctf"
  }
}
resource "aws_subnet" "private"{
  vpc_id = aws_vpc.vpc-main.id
  cidr_block = "10.0.0.128/28"
    tags = {
    Name    = "cloud-ctf-subnet-private"   # ← TO jest nazwa widoczna w konsoli
    Project = "cloud-ctf"
  }
}
resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.vpc-main.id

}
