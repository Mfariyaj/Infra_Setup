resource "aws_security_group" "sg" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = "Managed by Terraform"

  tags = merge(var.tags, { "Name" = var.sg_name })
}

resource "aws_security_group_rule" "ingress" {
  count       = length(var.ingress_rules)
  type        = "ingress"
  from_port   = var.ingress_rules[count.index].from_port
  to_port     = var.ingress_rules[count.index].to_port
  protocol    = var.ingress_rules[count.index].protocol
  cidr_blocks = var.ingress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress" {
  count       = length(var.egress_rules)
  type        = "egress"
  from_port   = var.egress_rules[count.index].from_port
  to_port     = var.egress_rules[count.index].to_port
  protocol    = var.egress_rules[count.index].protocol
  cidr_blocks = var.egress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.sg.id
}


