provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "chatbot" {
  name = "chatbot-api"
}

resource "null_resource" "push_image" {
  triggers = {
    image_tag = var.image_tag
  }

  provisioner "local-exec" {
    command = <<EOF
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.chatbot.repository_url}
      docker tag chatbot-api:${var.image_tag} ${aws_ecr_repository.chatbot.repository_url}:${var.image_tag}
      docker push ${aws_ecr_repository.chatbot.repository_url}:${var.image_tag}
    EOF
  }
}

resource "aws_ecs_cluster" "main" {
  name = "chatbot-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "chatbot-app"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "chatbot-container"
      image = "${aws_ecr_repository.chatbot.repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "OPENAI_API_KEY"
          value = var.openai_api_key
        },
        {
          name  = "SUPABASE_URL"
          value = var.supabase_url
        },
        {
          name  = "SUPABASE_KEY"
          value = var.supabase_key
        },
        {
          name  = "ENVIRONMENT"
          value = "production"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/chatbot"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "chatbot-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "chatbot-container"
    container_port   = 8000
  }

  depends_on = [null_resource.push_image]
}

resource "aws_security_group" "ecs_tasks" {
  name        = "chatbot-ecs-tasks"
  description = "Allow inbound traffic for chatbot"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "chatbot" {
  name              = "/ecs/chatbot"
  retention_in_days = 30
} 