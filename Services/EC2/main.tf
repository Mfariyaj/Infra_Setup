resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = null # Keep null, as we use security_group_ids below
  vpc_security_group_ids = var.security_group_ids
  key_name      = var.key_name
  user_data     = file("${path.module}/eks-install.sh")
  tags          = merge(var.tags, { "Name" = var.instance_name })

  # Add root_block_device to increase the root volume size
  root_block_device {
    volume_size = 30 # Set the desired size in GB (e.g., 30 GB)
    volume_type = "gp3" # You can change this to "gp3" or other types if needed
    # Optional: Add tags to the root volume
    tags = merge(var.tags, { "Name" = "${var.instance_name}-root-volume" })
  }
}

data "aws_subnet" "selected_subnet" {
  id = var.subnet_id
}
