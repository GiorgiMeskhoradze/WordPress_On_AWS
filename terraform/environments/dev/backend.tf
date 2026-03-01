terraform {
  backend "s3" {
    bucket = "my-terraform-backend-for-learning"
    key = "I Should Add the Key"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }
}