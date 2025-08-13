resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"
  tags = local.labels
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
  tags              = local.labels
}

# IAM: Execution role (pull image, write logs)
data "aws_iam_policy_document" "task_exec_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "${local.family}-exec-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
  tags               = local.labels
}

resource "aws_iam_role_policy_attachment" "task_exec_attach_1" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${local.family}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
  tags               = local.labels
}

resource "aws_security_group" "alb" {
  name        = "${local.family}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id
  tags        = local.labels
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  description       = "HTTP from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "service" {
  name        = "${local.family}-svc-sg"
  description = "Service security group"
  vpc_id      = var.vpc_id
  tags        = local.labels
}

resource "aws_vpc_security_group_ingress_rule" "svc_from_alb" {
  security_group_id            = aws_security_group.service.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = local.container_port
  to_port                      = local.container_port
  description                  = "ALB to service"
}

resource "aws_vpc_security_group_egress_rule" "svc_all_out" {
  security_group_id = aws_security_group.service.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ALB
resource "aws_lb" "this" {
  name               = "${local.family}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids
  idle_timeout       = 60
  tags               = local.labels
}

resource "aws_lb_target_group" "this" {
  name        = substr("${local.family}-tg", 0, 32)
  port        = local.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = var.health_check_path
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = local.labels
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.task_cpu
  memory                   = local.task_memory
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([
    {
      name      = "${local.family}"
      image     = var.image
      essential = true
      portMappings = [{
        containerPort = local.container_port
        hostPort      = local.container_port
        protocol      = "tcp"
      }]
      environment = [
        for k, v in var.environment : { name = k, value = v }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = local.family
        }
      }
      healthCheck = var.container_healthcheck == null ? null : {
        command     = var.container_healthcheck.command
        interval    = var.container_healthcheck.interval
        timeout     = var.container_healthcheck.timeout
        retries     = var.container_healthcheck.retries
        startPeriod = var.container_healthcheck.start_period
      }
    }
  ])

  tags = local.labels
}

resource "aws_ecs_service" "this" {
  name            = "${local.family}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.service.id]
    subnets          = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.family
    container_port   = local.container_port
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 20

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = local.labels

  depends_on = [aws_lb_listener.http]
}