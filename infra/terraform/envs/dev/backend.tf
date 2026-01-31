terraform {
  backend "s3" {
    bucket = "your-dev-tfstate-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
