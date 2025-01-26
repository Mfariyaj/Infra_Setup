variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "eks_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}
