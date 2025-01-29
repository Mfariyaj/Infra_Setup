terraform {
  backend "s3" {
    bucket         = "s3-bucket-fariyaj"
    key            = "backend_s3/terraform.tfstate"
    region         = "us-east-1"
  }
}
