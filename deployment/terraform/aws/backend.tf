terraform {
  backend "s3" {
    bucket = "bucket4oregon"
    key    = "eks/terraform.tfstate"
    region = "us-west-2"
  }
}