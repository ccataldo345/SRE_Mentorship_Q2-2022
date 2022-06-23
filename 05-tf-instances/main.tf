provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

// Create Security Group:
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  // vpc_id = "vpc-09e25fb07f9d8c373"
  vpc_id = aws_default_vpc.default.id

  // HTTP:
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // range of IP addresses access allowed (all)
  }

  // SSH:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0  // all ports
    to_port     = 0  // all ports
    protocol    = -1 // all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

// Create an AWS instance (EC2 Virtual Server)
resource "aws_instance" "http_server" {
  # ami                    = "ami-0cff7528ff583bf9a"
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  // subnet_id              = "subnet-061a51286cb94f112" // VPC > Subnets (pic any default (witohout name))
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[0]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y", // install httpd 
      "sudo service httpd start",  // start httpd 
      "echo Virtual Server link: ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}


// ami-0cff7528ff583bf9a
// vpc-09e25fb07f9d8c373
