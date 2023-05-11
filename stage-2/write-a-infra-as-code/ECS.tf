# Create the ECS cluster
resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx"
}

# Create the task definition
resource "aws_ecs_task_definition" "nginx_task" {
  family = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "nginx_container"
      image = "nginx:latest"
      cpu    = 256
      memory = 512
      essential = true
      portMappings = [
        {
          "containerPort" : 80
          "hostPort" : 80
        }
      ]
  }])

}

# Create the ECS service
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 2
  launch_type = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups = [aws_security_group.nginx_sg.id]
    subnets = ["subnet-1", "subnet-2"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name = "nginx_container"
    container_port = 80
  }

}