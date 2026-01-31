terraform {
  backend "s3" {
    bucket = "your-uat-tfstate-bucket"
    key    = "uat/terraform.tfstate"
    region = "us-east-1"
  }
}
