variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  sensitive   = true
}

variable "supabase_url" {
  description = "Supabase URL"
}

variable "supabase_key" {
  description = "Supabase Key"
  sensitive   = true
}

variable "environment" {
  description = "Environment (production/staging)"
  type        = string
} 