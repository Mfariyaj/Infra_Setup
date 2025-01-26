variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_instance_type" {
  description = "Instance type for the worker nodes"
  type        = string
}

variable "node_group_size" {
  description = "Desired number of worker nodes"
  type        = number
}
