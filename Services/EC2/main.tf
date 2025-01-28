resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = null # Keep null, as we use security_group_ids below
  vpc_security_group_ids = var.security_group_ids
  key_name      = var.key_name
  user_data = file("${path.module}/eks-install.sh")
  tags = merge(var.tags, { "Name" = var.instance_name })
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = var.instance_type
  size              = 15

}

