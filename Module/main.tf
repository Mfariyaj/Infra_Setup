provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
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

module "ec2_instance" {
  source             = "../Services/EC2"
  instance_name      = var.instance_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  subnet_id          = element(module.vpc.public_subnet_ids, 0)
  security_group_ids = [module.security_group.security_group_id]
  key_name           = var.key_name
  tags               = var.tags
}

#module "IAM_EKS_Role" {

#  source = "../Services/iam-policy-eks"
#}

module "eks" {
  source              = "../Services/EKS"
  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  public_subnets      = [module.vpc.public_subnet_ids]
  private_subnets     = [module.vpc.private_subnet_ids]
  cluster_role_arn    = aws_iam_role.eks_cluster_role.arn
  node_role_arn       = aws_iam_role.eks_worker_role.arn
}


