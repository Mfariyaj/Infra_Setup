module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id             = var.vpc_id
  subnet_ids         = concat(var.public_subnet_ids, var.private_subnet_ids)
  cluster_role_arn   = var.cluster_role_arn
  node_role_arn      = var.node_role_arn

  node_groups = {
    eks_node_group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"
      key_name      = var.key_name
    }
  }
}
