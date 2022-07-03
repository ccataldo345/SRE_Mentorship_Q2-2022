provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

// Create Security Group for Public server:
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  // vpc_id = aws_default_vpc.default.id

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
    name = "http_server_sg"
  }
}

// Create an AWS instance (EC2 Virtual Server)
resource "aws_instance" "http_server" {
  ami                     = data.aws_ami.aws_linux_2_latest.id
  key_name                = "default-ec2"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.http_server_sg.id]
  subnet_id               = tolist(data.aws_subnet_ids.default_subnets.ids)[0]
  associate_public_ip_address = "true"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  user_data = file("install_httpd.sh")
}

// Create Security Group for Private server:
resource "aws_security_group" "private_server_sg" {
  name   = "private_server_sg"
  // vpc_id = aws_default_vpc.default.id

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

  ingress {
    from_port   = 443
    to_port     = 443
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
    name = "private_server_sg"
  }
}

// Create a Private AWS instance (EC2 Virtual Server)
resource "aws_instance" "private_server" {
  ami                     = data.aws_ami.aws_linux_2_latest.id
  key_name                = "default-ec2"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.private_server_sg.id]
  subnet_id               = tolist(data.aws_subnet_ids.default_subnets.ids)[1]
  associate_public_ip_address = "false"

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  user_data = file("install_httpd.sh")

  tags = {
    name = "private_server"
  }
}


// create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_default_vpc.default.id

  tags = {
    name = "Internet Gateway"
  }
}

// create a Public Route Table for the Public server
resource "aws_route_table" "public_rt" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }

  tags = {
    name = "Public Route Table"
  }
}

// Create association between Public Server and Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_instance.http_server.id
  route_table_id = aws_route_table.public_rt.id
}

/*
Error: error attaching EC2 Internet Gateway (igw-0f951321189bd134c) to VPC (vpc-09e25fb07f9d8c373): InvalidParameterValue: Network vpc-09e25fb07f9d8c373 already has an internet gateway attached
│       status code: 400, request id: 55f0a30b-bcb3-4c23-9430-d4f2b0e4358b
│
│   with aws_internet_gateway.igw,
│   on main.tf line 126, in resource "aws_internet_gateway" "igw":
│  126: resource "aws_internet_gateway" "igw" {
*/
