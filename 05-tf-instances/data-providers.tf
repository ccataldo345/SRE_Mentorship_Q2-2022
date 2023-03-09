// data provider:
# data "aws_subnet_ids" "default_subnets" {
#   vpc_id = aws_default_vpc.default.id
# }

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}
# TF console: data.aws_subnets.default_subnets
# echo data.aws_subnets.default_subnets.ids[0] | terraform console
# AWS > VPC > Subnets

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami_ids" "aws_linux_2_latest_ids" {
  owners = ["amazon"]
}

# echo data.aws_ami.aws_linux_2_latest.id | terraform console