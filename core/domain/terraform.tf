terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "tedilabs"

    workspaces {
      name = "example-aws-domain"
    }
  }
}


###################################################
# Local Variables
###################################################

locals {
  aws_accounts = {
    example = {
      id     = "777777777777",
      region = "ap-northeast-2",
      alias  = "example",
    },
  }
  config = yamldecode(file(var.config_file))
}


###################################################
# Providers
###################################################

provider "aws" {
  region = local.aws_accounts.example.region

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [local.aws_accounts.example.id]

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_accounts.example.id}:role/allow-full-access"
    session_name = "example-aws-domain"
  }
}
