# Creating Nat Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "Nat Gateway EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "Nat Gateway"
  }
}

# Add routes for VPC
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

# Creating route associations for private Subnets
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
