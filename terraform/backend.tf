terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    # Note: Don't specify the values here, they will be passed via backend-config
    # during terraform init in the GitHub Actions workflow
  }
} 