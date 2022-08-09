module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-modules"
  cidr = "10.0.0.0/18"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.0.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_vpc" "vpc_id" {
  tags = {
    Name = var.vpc
  }
}

variable "vpc" {}

data "aws_vpc" "example" {
  tags = {
    Name = var.vpc
  }
}

data "aws_subnet_ids" "example" {
  vpc_id = data.aws_vpc.example.id

  tags = {
    Tier = "private"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain
resource "aws_opensearch_domain" "elastic-search" {
  domain_name    = "cc_ELK"
  engine_version = "OpenSearch_1.0"

  cluster_config {
    instance_type = "m4.large.search"
    zone_awareness_enabled = true
    
    dedicated_master_count = 3
    dedicated_master_enabled = true
    dedicated_master_type = "t2.medium.elasticsearch"
  }

  vpc_options {
    subnet_ids = [
      data.aws_subnet_ids.example.ids[0],
      data.aws_subnet_ids.example.ids[1],
    ]
  }

   log_publishing_options = [
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "INDEX_SLOW_LOGS"
      enabled                  = true
    },
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "SEARCH_SLOW_LOGS"
      enabled                  = true
    },
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "ES_APPLICATION_LOGS"
      enabled                  = true
    }
  ]

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG

  tags = {
    Domain = "cc_ELK_TestDomain"
  }
}
