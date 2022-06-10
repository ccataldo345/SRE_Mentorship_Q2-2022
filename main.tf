terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-chris345-001"
    versioning {
        enabled = true
    }
} 

output "my_s3_bucket_versioning" {
	value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}
