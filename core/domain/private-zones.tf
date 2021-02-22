module "private_zone" {
  source  = "app.terraform.io/tedilabs/domain/aws//modules/private-zone"
  version = "0.4.0"

  for_each = {
    for zone in local.config.private_zones:
      zone.name => zone
  }

  name    = each.value.name
  comment = lookup(each.value, "comment", "Managed by Terraform")

  authorized_cross_account_vpc_associations = lookup(each.value, "authorized_cross_account_vpc_associations", [])

  tags = {}
}
