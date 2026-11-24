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
  # Kaynak adları ortam başına benzersiz olmalı; aksi halde dev ve prod
  # aynı hesapta çakışır (key pair, IAM role ve security group adları tekildir).
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_key_pair" "BGD_key" {
  key_name   = "${local.name_prefix}-key"
  public_key = file(pathexpand(var.public_key_path))
}

resource "aws_iam_role" "BGD_role" {
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
  role       = aws_iam_role.BGD_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "BGD_instance_profile" {
  name       = "${local.name_prefix}-ec2-profile"
  role       = aws_iam_role.BGD_role.name
  depends_on = [aws_iam_role_policy_attachment.ssm_attach]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name               = aws_key_pair.BGD_key.key_name
  vpc_security_group_ids = [aws_security_group.BGD_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.BGD_instance_profile.name

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  tags = {
    Name = "${local.name_prefix}-web"
  }

  lifecycle {
    # Canonical yeni AMI yayınladığında "most_recent" farklı bir ID döner.
    # Bunu yok saymazsak dokunulmamış ortamda plan, instance'ı yeniden
    # oluşturmak ister. AMI güncellemesi bilinçli yapılmalı (taint/replace).
    ignore_changes = [ami]
  }
}

#Elastic IP
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip"
  }
}

# Security Group for EC2 Instances

resource "aws_security_group" "BGD_security_group" {
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

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
