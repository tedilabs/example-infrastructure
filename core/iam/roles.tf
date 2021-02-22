module "role__allow_full_access" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-role"
  version = "0.4.0"

  name = "allow-full-access"
  path = "/"

  trusted_iam_entities = ["arn:aws:iam::${local.aws_accounts.example.id}:root"]
  policies             = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  tags = {}
}

module "role__allow_read_only" {
  source  = "app.terraform.io/tedilabs/account/aws//modules/iam-role"
  version = "0.4.0"

  name = "allow-read-only"
  path = "/"

  trusted_iam_entities = ["arn:aws:iam::${local.aws_accounts.example.id}:root"]
  policies             = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  tags = {}
}
