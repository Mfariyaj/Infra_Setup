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

resource "aws_instance" "install_argocd_monitoring_tool" {
  depends_on = [data.aws_instance.ec2]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user" # Update based on your OS (e.g., ubuntu for Ubuntu AMIs)
      private_key = file("~/.ssh/my-key.pem") # Ensure this path is correct and accessible
      host        = data.aws_instance.ec2.public_ip
    }

    inline = [
      "sudo yum install -y jq",  # Use apt for Ubuntu
      "kubectl create namespace argocd",
      "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml",
      "kubectl wait --for=condition=available --timeout=600s deployment -n argocd -l app.kubernetes.io/name=argocd-server",
      "kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'",
      "export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq -r '.status.loadBalancer.ingress[0].hostname')",
      "export ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d)",
      "echo \"ArgoCD Server: $ARGOCD_SERVER\"",
      "echo \"ArgoCD Admin Password: $ARGO_PWD\"",
      "helm repo add stable https://charts.helm.sh/stable",
      "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts",
      "helm repo add grafana https://grafana.github.io/helm-charts",
      "helm repo update",
      "helm install prometheus prometheus-community/prometheus",
      "helm install grafana grafana/grafana"
    ]
  }
}
