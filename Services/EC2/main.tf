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
  availability_zone = data.aws_subnet.selected_subnet.availability_zone
  size              = 15
  tags = merge(var.tags, { "Name" = "${var.instance_name}-ebs" })
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf" # Update as needed
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.ec2.id
}

data "aws_subnet" "selected_subnet" {
  id = var.subnet_id
}
