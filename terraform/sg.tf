# Web SG: allow HTTP/80 from anywhere, SSH/22 only from your IP
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Web/App security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-web-sg" }
}

# DB SG: allow MongoDB 27017 from web_sg only (no public)
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "MongoDB private SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MongoDB from web"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Optional: SSH from web (bastion) if you want to hop through
  ingress {
    description     = "SSH from web"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-db-sg" }
}
