variable "names" {
  # default = ["chris", "tom", "jane"]
  # default = ["mark", "chris", "tom", "jane"]
  default = ["lisa", "mark", "chris", "tom", "jane"]
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "my_iam_users" {
  # count = length(var.names)
  # name  = var.names[count.index]
  for_each = toset(var.names)
  name     = each.value
}
