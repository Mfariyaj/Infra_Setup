# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    # bootstrap_cluster_creator_admin_permissions = true # it will give the full admin access to creator of eks user
  }

  vpc_config {
    subnet_ids = var.public_subnets
  }

  tags = {
    Name = var.cluster_name
  }
}

# Node Group
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  node_group_name = "eks-node-group"
  subnet_ids      = var.public_subnets
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name = "EKS-Node-Group"
  }
}

# EKS Add-ons
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"
}

resource "aws_eks_addon" "core_dns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

