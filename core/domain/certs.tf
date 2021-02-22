###################################################
# Amazon-issued Certs
###################################################

module "amazon_cert" {
  source  = "app.terraform.io/tedilabs/domain/aws//modules/amazon-issued-cert"
  version = "0.4.0"

  for_each = {
    for cert in local.config.certs.amazon :
    cert.name => cert
  }

  name                      = each.value.name
  subject_name              = each.value.subject_name
  subject_alternative_names = lookup(each.value, "subject_alternative_names", [])

  validation_dns_managed       = true
  validation_dns_managed_zones = {
    "x.tedilabs.com"  = module.public_zone__primary["x.tedilabs.com"].id,
    "tedilabs.net"    = module.public_zone__primary["tedilabs.net"].id,
    "kr.tedilabs.net" = module.public_zone__primary["kr.tedilabs.net"].id,
    "jp.tedilabs.net" = module.public_zone__primary["jp.tedilabs.net"].id,
  }

  tags = {}
}
