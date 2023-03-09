provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

// Create Security Group:
resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  vpc_id = aws_default_vpc.default.id

  // HTTP:
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // range of IP addresses access allowed (all)
  }

  egress {
    from_port   = 0  // all ports
    to_port     = 0  // all ports
    protocol    = -1 // all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}

// create resources for the load balancer:
resource "aws_elb" "elb" {
  name            = "elb"
  subnets         = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = values(aws_instance.http_servers).*.id
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

// Create a Key Pair .pem file:
// Create a Public Key Pair in AWS > EC2
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

// Create an AWS instance (EC2 Virtual Server)
resource "aws_instance" "http_servers" {
  # ami                    = "ami-0cff7528ff583bf9a"
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "tf-key-pair"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.elb_sg.id]
  // subnet_id              = "subnet-061a51286cb94f112" // VPC > Subnets (pic any default (witohout name))
  # for_each  = data.aws_subnet_ids.default_subnets.ids   // old TF version
  for_each  = toset(data.aws_subnets.default_subnets.ids)
  subnet_id = each.value

  tags = {
    name : "http_servers_${each.value}"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  user_data = file("install_httpd.sh")
}
