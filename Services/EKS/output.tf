output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_worker_arn" {
  value = aws_eks_cluster.eks_worker.arn
}

output "node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}
