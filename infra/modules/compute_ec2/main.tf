# IAM Role para que EC2 pueda asumir permisos
resource "aws_iam_role" "this" {
  name = "${var.name}-${var.environment}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Política inline: solo s3:GetObject sobre server.rb
resource "aws_iam_role_policy" "s3_read" {
  name = "${var.name}-${var.environment}-s3-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:GetObject"
      Resource = "arn:aws:s3:::${var.app_s3_bucket}/server.rb"
    }]
  })
}

# Instance profile (EC2 no acepta el role ARN directamente)
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-${var.environment}-profile"
  role = aws_iam_role.this.name
}

# Security group: solo puerto 8080 desde allowed_cidr_blocks
resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Allow inbound TCP 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y ruby
    aws s3 cp s3://${var.app_s3_bucket}/server.rb /opt/server.rb
    COMPUTE_TYPE=ec2 nohup ruby /opt/server.rb &
  EOF

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}