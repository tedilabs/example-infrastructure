resource "aws_route53_delegation_set" "this" {
  for_each = toset(local.config.delegation_sets)

  reference_name = each.value
}

module "public_zone__primary" {
  source  = "app.terraform.io/tedilabs/domain/aws//modules/public-zone"
  version = "0.4.0"

  for_each = {
    for zone in local.config.public_zones.primary:
      zone.name => zone
  }

  name    = each.value.name
  comment = lookup(each.value, "comment", "Managed by Terraform")

  delegation_set_id = aws_route53_delegation_set.this["primary"].id

  tags = {}
}

module "public_zone__secondary" {
  source  = "app.terraform.io/tedilabs/domain/aws//modules/public-zone"
  version = "0.4.0"

  for_each = {
    for zone in local.config.public_zones.secondary:
      zone.name => zone
  }

  name    = each.value.name
  comment = lookup(each.value, "comment", "Managed by Terraform")

  delegation_set_id = aws_route53_delegation_set.this["secondary"].id

  tags = {}
}


resource "aws_route53_record" "name_servers" {
  for_each = toset([for zone in local.config.public_zones.secondary: zone.name])

  zone_id = module.public_zone__primary[regex("^[^.]+\\.(.*)", each.value)[0]].id
  name    = each.value
  type    = "NS"
  ttl     = "30"
  records = module.public_zone__secondary[each.value].name_servers
}
