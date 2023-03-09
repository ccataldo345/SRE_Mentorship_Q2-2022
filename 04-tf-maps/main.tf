variable "users" {
  default = {
    # lisa: "UK",
    # mark: "USA",
    # chris: "EU"
    lisa : { country : "UK", department : "ABC" },
    mark : { country : "USA", department : "CDE" },
    chris : { country : "EU", department : "XYZ" }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    # country : each.value
    country : each.value.country
    department : each.value.department
  }
}
