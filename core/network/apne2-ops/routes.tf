resource "aws_default_route_table" "this" {
  default_route_table_id = module.vpc.default_route_table_id

  tags = {
    "Name" = "${module.vpc.name}-default"
  }
}


###################################################
# Route Tables for App Subnets
###################################################

module "route_table__app_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/route-table"
  version = "0.8.0"

  for_each = toset(["apne2-az1", "apne2-az2", "apne2-az3"])

  name   = "${module.vpc.name}-app-private/${each.value}"
  vpc_id = module.vpc.id

  subnets = [
    for subnet in concat(
      module.subnet_group__app_private.subnets,
    ):
      subnet.id if subnet.availability_zone_id == each.value
  ]

  # TODO: Use NAT Gateway from each AZ for HA.
  ipv4_routes = [{
    cidr_block     = "0.0.0.0/0",
    nat_gateway_id = module.nat_gw["apne2-az1"].id,
  }]

  tags = {}
}


###################################################
# Route Tables for Data Subnets
###################################################

module "route_table__data_private_managed" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/route-table"
  version = "0.8.0"

  name   = "${module.vpc.name}-data-private-managed"
  vpc_id = module.vpc.id

  subnets = concat(
    module.subnet_group__data_private_managed.ids,
  )

  ipv4_routes = []

  tags = {}
}

module "route_table__data_private_self" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/route-table"
  version = "0.8.0"

  for_each = toset(["apne2-az1", "apne2-az2", "apne2-az3"])

  name   = "${module.vpc.name}-data-private-self/${each.value}"
  vpc_id = module.vpc.id

  subnets = [
    for subnet in concat(
      module.subnet_group__data_private_self.subnets,
    ):
      subnet.id if subnet.availability_zone_id == each.value
  ]

  # TODO: Use NAT Gateway from each AZ for HA.
  ipv4_routes = [{
    cidr_block     = "0.0.0.0/0",
    nat_gateway_id = module.nat_gw["apne2-az1"].id,
  }]

  tags = {}
}


###################################################
# Route Tables for Network Subnets
###################################################

module "route_table__net_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/route-table"
  version = "0.8.0"

  for_each = toset(["apne2-az1", "apne2-az2", "apne2-az3"])

  name   = "${module.vpc.name}-net-private/${each.value}"
  vpc_id = module.vpc.id

  subnets = [
    for subnet in concat(
      module.subnet_group__net_private.subnets,
    ):
      subnet.id if subnet.availability_zone_id == each.value
  ]

  ipv4_routes = [{
    cidr_block = "0.0.0.0/0",
    nat_gateway_id = module.nat_gw["apne2-az1"].id,
  }]

  tags = {}
}

module "route_table__net_public" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/route-table"
  version = "0.8.0"

  name   = "${module.vpc.name}-net-public"
  vpc_id = module.vpc.id

  subnets = concat(
    module.subnet_group__net_public.ids,
  )

  ipv4_routes = [{
    cidr_block = "0.0.0.0/0",
    gateway_id = module.vpc.internet_gateway_id,
  }]

  tags = {}
}
