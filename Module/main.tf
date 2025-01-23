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
module "security_group" {
  source  = "../Services/SG"
  sg_name = var.sg_name
  vpc_id  = var.vpc_id

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
  tags          = var.tags
}

module "ec2_instance" {
  source             = "../Services/EC2"
  instance_name      = var.instance_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = var.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  key_name           = var.key_name
  tags               = var.tags
}

output "ec2_instance_id" {
  value = module.ec2_instance.instance_id
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}
