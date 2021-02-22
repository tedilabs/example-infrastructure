module "group__administrators" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-group"
  version = "0.4.0"

  name            = "administrators"
  path            = "/tedilabs/"
  assumable_roles = [
    "arn:aws:iam::${local.aws_accounts.example.id}:role/*",
  ]
  policies        = []
}

module "group__employees" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-group"
  version = "0.4.0"

  name            = "employees"
  path            = "/tedilabs/"
  assumable_roles = []
  policies        = []
  inline_policies = {}
}

module "group__partners" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-group"
  version = "0.4.0"

  name            = "partners"
  path            = "/3rd-party/"
  assumable_roles = []
  policies        = []
  inline_policies = {}
}


###################################################
# Team
###################################################

module "group__team_devops" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-group"
  version = "0.4.0"

  name            = "team-devops"
  path            = "/tedilabs/"
  assumable_roles = [
    "arn:aws:iam::${local.aws_accounts.example.id}:role/*",
  ]
  policies        = []
}


###################################################
# ETC
###################################################

module "group__systems" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-group"
  version = "0.4.0"

  name            = "systems"
  path            = "/"
  assumable_roles = []
  policies        = []
  inline_policies = {}
}


###################################################
# Managed
###################################################

module "managed_groups" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/managed-groups"
  version = "0.4.0"

  self_service_password_enabled = true
}
