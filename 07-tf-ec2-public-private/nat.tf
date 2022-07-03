# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    name = "NAT Gateway EIP"
  }
}

# NAT Gateway for VPC
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_instance.http_server.id
  tags = {
    name = "default VPC NAT Gateway"
  }
}

# Route Table for Private server
resource "aws_route_table" "private_rt" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id  = aws_nat_gateway.nat.id
  }

  tags = {
    name = "Private Route Table"
  }
}

# Association between the Private Server and the Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_instance.private_server.id
  route_table_id = aws_route_table.private_rt.id
}