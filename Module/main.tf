provider "aws" {
  region = var.region
}

module "vpc" {
  source           = "../Services/VPC"
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  region           = var.region
  tags             = var.tags
}


