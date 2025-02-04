terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  
  backend "s3" {
    bucket               = "chatbot-terraform-state-bucket"
    key                  = "terraform.tfstate"
    region              = "us-east-1"
    dynamodb_table      = "chatbot-terraform-state-locks"
    encrypt             = true
    workspace_key_prefix = "env"  # This will store state files as env/production/terraform.tfstate
  }
} 