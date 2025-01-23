# Creating EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "AWS-EKS"
  role_arn = var.master_arn
  subnet_id     = var.subnet_id
  tags = merge(var.tags, { "Name" = var.aws_eks_cluster })

}

# # Using Data Source to get all Avalablility Zones in Region
# data "aws_availability_zones" "available_zones" {}

# # Fetching Ubuntu 20.04 AMI ID
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"]
# }

# Creating kubectl server
resource "aws_instance" "kubectl-server" {
  ami                         = var.ami_id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "${var.project_name}-kubectl"
  }
}

# Creating Worker Node Group
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name
  node_role_arn   = var.worker_arn
  subnet_id     = var.subnet_id
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = [var.instance_type]

  remote_access {
    ec2_ssh_key               = var.key_name
    vpc_security_group_ids = var.security_group_ids
  }

  labels = {
    env = "Prod"
  }

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}