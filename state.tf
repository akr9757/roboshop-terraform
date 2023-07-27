terraform {
  backend "s3" {
    bucket = "akr-terraform"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
