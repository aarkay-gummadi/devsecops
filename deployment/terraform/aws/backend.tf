terraform {
  backend "s3" {
    bucket = "bucket4oregon"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}