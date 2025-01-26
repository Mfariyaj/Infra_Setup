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
  value = module.aws_iam_role.master.arn
}

output "worker_arn" {
  value = module.aws_iam_role.worker.arn
}
