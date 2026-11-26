data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  name_prefix = "${var.project}-${var.environment}-monitoring"
}

resource "aws_key_pair" "monitoring" {
  key_name   = "${local.name_prefix}-key"
  public_key = file(pathexpand(var.public_key_path))
}

resource "aws_iam_role" "monitoring" {
  name = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "monitoring" {
  name       = "${local.name_prefix}-ec2-profile"
  role       = aws_iam_role.monitoring.name
  depends_on = [aws_iam_role_policy_attachment.ssm_attach]
}

resource "aws_instance" "monitoring" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name               = aws_key_pair.monitoring.key_name
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  iam_instance_profile   = aws_iam_instance_profile.monitoring.name

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  tags = {
    Name = "${local.name_prefix}-monitoring"
  }

  lifecycle {
    # Canonical yeni AMI yayınladığında "most_recent" farklı bir ID döner.
    ignore_changes = [ami]
  }
}

# Security Group for EC2 Instances

resource "aws_security_group" "monitoring" {
  name   = "${local.name_prefix}-sg"
  vpc_id = var.vpc_id
  tags = {
    Name = "${local.name_prefix}-sg"
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.ssh_allowed_cidr]
  }

ingress {
  description     = "Zabbix Agent Active Checks"
  from_port       = 10051
  to_port         = 10051
  protocol        = "tcp"
  security_groups = [var.agent_security_group_id]
}

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
