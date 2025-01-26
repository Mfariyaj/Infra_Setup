resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_public_access = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attachment,
    aws_iam_role_policy_attachment.eks_vpc_policy_attachment
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.node_instance_type]
  desired_size    = var.node_group_size
  min_size        = var.node_group_size
  max_size        = var.node_group_size

  depends_on = [
    aws_eks_cluster.main
  ]
}

