output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

#output "eks_cluster_name" {
#  value = module.eks.cluster_name
#}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_arn" {
  value = module.eks.eks_cluster_arn
}
output "eks_worker_arn" {
  value = module.eks.eks_worker_arn
}





