terraform {
  backend "s3" {
    bucket         = "sakthivelachuthans3"
    key            = "aws_vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}