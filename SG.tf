
resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.main_vpc.id


  tags = merge(local.common_tags, {
    Name = "SG"
  })
}

resource "aws_security_group_rule" "allow_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allow inbound HTTP traffic"
}

resource "aws_security_group_rule" "allow_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allow inbound HTTPS traffic"
}

resource "aws_security_group_rule" "SSH_connection" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allow SSH connection to server"
}

resource "aws_security_group_rule" "Alb_connection" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allow ALB to connect to SG"
}

resource "aws_security_group_rule" "Aurora_DB" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allows connection to Aurora DB"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg.id
  description       = "Allow all outbound traffic"
}
