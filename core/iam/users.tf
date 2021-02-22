###################################################
# IAM Users for Employees
###################################################

module "user__claud" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-user"
  version = "0.4.0"

  name          = "claud@tedilabs.com"
  path          = "/tedilabs/engineering/"
  force_destroy = true

  pgp_key            = "keybase:posquit0"
  create_access_key  = true
  access_key_enabled = true

  groups = [
    "administrators", "employees", "team-devops",
    module.managed_groups.groups["self-service-password"].name,
  ]

  # TODO: Add tags
  tags = {}
}


###################################################
# IAM Users for Partners
###################################################


###################################################
# IAM Users for Systems
###################################################

module "user__terraform" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-user"
  version = "0.4.0"

  name          = "terraform"
  path          = "/systems/"
  force_destroy = true

  pgp_key              = "keybase:test"
  create_login_profile = false
  create_access_key    = true
  access_key_enabled   = true

  groups          = ["systems"]
  assumable_roles = [
    "arn:aws:iam::${local.aws_accounts.example.id}:role/allow-full-access",
  ]

  # TODO: Add tags
  tags = {}
}
