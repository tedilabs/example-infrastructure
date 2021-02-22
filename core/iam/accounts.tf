###################################################
# Data
###################################################

locals {
  accounts = {
    for k, v in local.aws_accounts:
      k => merge(v, {
        signin_url = "https://${v.alias}.signin.aws.amazon.com/console"
      })
  }
}


###################################################
# Resources
###################################################

resource "aws_iam_account_alias" "this" {
  for_each = local.accounts

  account_alias = each.value.alias
}

module "password_policy" {
  for_each = local.accounts

  source = "../../modules/iam-password-policy"
}
