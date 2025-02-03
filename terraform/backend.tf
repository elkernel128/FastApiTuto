terraform {
  backend "s3" {
    bucket         = "chatbot-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "chatbot-terraform-state-locks"
    encrypt        = true
  }
} 