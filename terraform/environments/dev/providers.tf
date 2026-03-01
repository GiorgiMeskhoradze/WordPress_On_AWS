# Cloud Provider(s)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

# Define Region Ror My Iac
provider "aws" {
  region = var.region
}