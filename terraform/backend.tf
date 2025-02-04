terraform {
  required_version = ">= 1.0.0"
  
  backend "s3" {
    # Empty config here - values will be passed via backend-config
    # during terraform init in the GitHub Actions workflow
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
} 