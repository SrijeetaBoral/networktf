locals {
  tags = { Project = var.project_id }
}

resource "aws_security_group" "ssh" {
  name   = "${var.project_id}-ssh-sg"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group" "public_http" {
  name   = "${var.project_id}-public-http-sg"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group" "private_http" {
  name   = "${var.project_id}-private-http-sg"
  vpc_id = var.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "ssh_22" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = var.allowed_ip_range
}

resource "aws_security_group_rule" "ssh_icmp" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = var.allowed_ip_range

}

resource "aws_security_group_rule" "public_80" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = var.allowed_ip_range
}

resource "aws_security_group_rule" "public_icmp" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http.id
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = var.allowed_ip_range
}

# Private HTTP SG: only from the public SG (no CIDRs)
resource "aws_security_group_rule" "private_8080" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_http.id
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "private_icmp" {
  type                     = "ingress"
  security_group_id        = aws_security_group.private_http.id
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.public_http.id

}


data "aws_instance" "public" {
  instance_id = var.public_instance_id
}

data "aws_instance" "private" {
  instance_id = var.private_instance_id
}

resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_instance.public.network_interface_id

}
resource "aws_network_interface_sg_attachment" "public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = data.aws_instance.public.network_interface_id

}
resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_instance.private.network_interface_id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = data.aws_instance.private.network_interface_id
}