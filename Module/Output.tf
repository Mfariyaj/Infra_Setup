output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "master_arn" {
  value = module.IAM_EKS_Role.master_arn
}

output "worker_arn" {
  value = module.IAM_EKS_Role.worker_arn
}