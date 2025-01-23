variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "master_arn" {
  description = "arn of the master_eks_role"
  type        = string
}
variable "worker_arn" {
  description = "arn of the worker_arn_role"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "name of the eks ec2-server"
  type        = string
  default     = "eks-server"
}


variable "node_group_name" {
  description = "name of the node_group"
  type        = string
}
