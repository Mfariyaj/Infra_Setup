output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}
