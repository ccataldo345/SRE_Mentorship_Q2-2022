# Create Security Groups
resource "aws_security_group" "public_sg" {
  description = "Allow limited inbound external traffic"
  name        = "Public_sg"
  vpc_id      = aws_vpc.dev_vpc.id
  tags = {
    Name = "Security_Group"
  }
}

resource "aws_security_group" "private_sg" {
  name   = "Private_sg"
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "Security_Group"
  }
}

resource "aws_security_group_rule" "ssh_rule_in_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "ssh_rule_in_private" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id        = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "http_rule_in" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id        = aws_security_group.private_sg.id
}

resource "aws_security_group_rule" "http_rule_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_sg.id
}

// Create a Key Pair .pem file:
// Create a Public Key Pair in AWS > EC2 > Key Pairs
resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
// Create a Private Key Pair pem file in the local folder
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "tf-key-pair.pem"
  file_permission = "0400"
}

// Create EC2 instance in Public subnet
resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "tf-key-pair"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  count                       = 1
  associate_public_ip_address = "true"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  user_data = file("install-httpd_public-server.sh")

  tags = {
    Name = "EC2_Public_instance"
  }

  depends_on = [
    aws_nat_gateway.nat_gw
  ]
}

// Create EC2 instance in Private subnet
resource "aws_instance" "private_instance" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "tf-key-pair"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  subnet_id                   = aws_subnet.private_subnet.id
  count                       = 1
  associate_public_ip_address = "false"
  user_data                   = file("install-httpd_private-server.sh")

  tags = {
    Name = "EC2_Private_instance"
  }

  depends_on = [
    aws_nat_gateway.nat_gw
  ]
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.public_sg.id
  network_interface_id = aws_instance.public_instance[0].primary_network_interface_id
}
