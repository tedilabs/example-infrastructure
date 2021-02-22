locals {
  nat_subnets = {
    for subnet in module.subnet_group__net_public.subnets:
      subnet.availability_zone_id => subnet.id...
  }
}

###################################################
# NAT Gateway
###################################################

module "nat_gw" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nat-gateway"
  version = "0.8.0"

  for_each = {
    for nat_gateway in local.config.nat_gateways:
      nat_gateway.az_id => nat_gateway
  }

  name      = each.value.name
  subnet_id = lookup(local.nat_subnets, each.value.az_id, "")[0]
  eip_id    = lookup(aws_eip.claud, each.value.eip, {}).id

  tags = {}
}
