# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  # enable_classiclink   = "false"  
  # WARNING: With the retirement of EC2-Classic the enable_classiclink attribute has been deprecated and will be removed in a future version.
  # ClassicLink allows you to link EC2-Classic instances to a VPC in your account, within the same Region. 
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html
  tags = {
    Name = "VPC"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public Subnet"
  }
}

# Creating Private Subnets in VPC
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Private Subnet"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "VPC Internet Gateway"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table for Internet Gateway"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
