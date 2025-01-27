output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_worker_arn" {
  description = "ARN of the IAM role assigned to EKS worker nodes, allowing them to interact with AWS resources"
  value       = aws_iam_role.eks_worker_role.arn
}
output "node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}
