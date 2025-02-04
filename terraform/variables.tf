variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "environment" {
  description = "Environment (production/staging)"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  sensitive   = true
}

variable "supabase_url" {
  description = "Supabase URL"
  type        = string
}

variable "supabase_key" {
  description = "Supabase Key"
  type        = string
  sensitive   = true
} 