terraform {
  backend "s3" {
    bucket = "your-prod-tfstate-bucket"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
