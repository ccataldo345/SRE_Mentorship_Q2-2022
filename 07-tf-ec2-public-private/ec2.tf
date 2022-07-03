# Create Security Groups
resource "aws_security_group" "security_group" {
  description = "Allow limited inbound external traffic"
  name        = "Private_sg"
  vpc_id      = aws_vpc.dev_vpc.id

  // HTTP:
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security_Group"
  }
}

// Create EC2 instance in Public subnet
resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "default-ec2"
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

  tags = {
    Name = "EC2_Public_instance"
  }
}

// Create EC2 instance in Private subnet
resource "aws_instance" "private_instance" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "default-ec2"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  subnet_id                   = aws_subnet.private_subnet.id
  count                       = 1
  associate_public_ip_address = "false"

  tags = {
    Name = "EC2_Private_instance"
  }
}
