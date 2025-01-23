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
  vpc_id  = module.vpc.vpc_id

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
  tags          = var.tags
}

# module "ec2_instance" {
#   source             = "../Services/EC2"
#   instance_name      = var.instance_name
#   ami_id             = var.ami_id
#   instance_type      = var.instance_type
#   subnet_id          = element(module.vpc.public_subnet_ids, 0)
#   security_group_ids = [module.security_group.security_group_id]
#   key_name           = var.key_name
#   tags               = var.tags
# }

module "IAM_EKS_Role" {

  source = "../Services/iam-policy-eks"
}

module "EKS" {

  source = "../Services/EKS" 
  instance_name      = var.instance_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids
  security_group_ids = [module.security_group.security_group_id]
  master_arn         = module.output.master_arn
  worker_arn       = module.output.worker_arn
  node_group_name    = var.node_group_name
  key_name           = var.key_name
  tags               = var.tags

}
