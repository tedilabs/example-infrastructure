resource "aws_default_network_acl" "this" {
  default_network_acl_id = module.vpc.default_network_acl_id

  tags = {
    "Name" = "${module.vpc.name}-default"
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}


###################################################
# App Subnets
###################################################

module "nacl__app_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nacl"
  version = "0.8.0"

  name    = "${module.vpc.name}-app-private"
  vpc_id  = module.vpc.id
  subnets = concat(
    module.subnet_group__app_private.ids,
  )

  ingress_rules = {
    # Ephemeral Ports
    800 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    801 = { action = "allow", protocol = "udp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }
  egress_rules = {
    900 = { action = "allow", protocol = "-1", cidr_block = "0.0.0.0/0" },
  }

  tags = {}
}


###################################################
# Data Subnets
###################################################

module "nacl__data_private_managed" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nacl"
  version = "0.8.0"

  name    = "${module.vpc.name}-data-private-managed"
  vpc_id  = module.vpc.id
  subnets = concat(
    module.subnet_group__data_private_managed.ids,
  )

  ingress_rules = {
    # RDS - MySQL
    400 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.cidr_block, from_port = 3306, to_port = 3306 },
    401 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.secondary_cidr_blocks[0], from_port = 3306, to_port = 3306 },
    # MSK - Kafka
    410 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.cidr_block, from_port = 2181, to_port = 2181 },
    411 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.secondary_cidr_blocks[0], from_port = 2181, to_port = 2181 },
    420 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.cidr_block, from_port = 9092, to_port = 9094 },
    421 = { action = "allow", protocol = "tcp", cidr_block = module.vpc.secondary_cidr_blocks[0], from_port = 9092, to_port = 9094 },
  }
  egress_rules = {
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }

  tags = {}
}

module "nacl__data_private_self" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nacl"
  version = "0.8.0"

  name    = "${module.vpc.name}-data-private-self"
  vpc_id  = module.vpc.id
  subnets = concat(
    module.subnet_group__data_private_self.ids,
  )

  ingress_rules = {
    # Ephemeral Ports
    800 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    801 = { action = "allow", protocol = "udp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }
  egress_rules = {
    900 = { action = "allow", protocol = "-1", cidr_block = "0.0.0.0/0" },
  }

  tags = {}
}


###################################################
# Network Subnets
###################################################

module "nacl__net_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nacl"
  version = "0.8.0"

  name    = "${module.vpc.name}-net-private"
  vpc_id  = module.vpc.id
  subnets = concat(
    module.subnet_group__net_private.ids,
  )

  ingress_rules = {
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }
  egress_rules = {
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }

  tags = {}
}

module "nacl__net_public" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/nacl"
  version = "0.8.0"

  name    = "${module.vpc.name}-net-public"
  vpc_id  = module.vpc.id
  subnets = concat(
    module.subnet_group__net_public.ids,
  )

  ingress_rules = {
    # ICMP
    100 = { action = "allow", protocol = "icmp", cidr_block = "0.0.0.0/0", icmp_type = -1, icmp_code = -1 },
    # Management
    200 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 22, to_port = 22 },
    # 210 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 3389, to_port = 3389 },
    220 = { action = "allow", protocol = "udp", cidr_block = "0.0.0.0/0", from_port = 1194, to_port = 1194 },
    # Load Balancer Ports
    300 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 80, to_port = 80 },
    310 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 443, to_port = 443 },
    # Ephemeral Ports
    800 = { action = "allow", protocol = "tcp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    801 = { action = "allow", protocol = "udp", cidr_block = "0.0.0.0/0", from_port = 1024, to_port = 65535 },
    # Internal
    900 = { action = "allow", protocol = "-1", cidr_block = module.vpc.cidr_block },
    901 = { action = "allow", protocol = "-1", cidr_block = module.vpc.secondary_cidr_blocks[0] },
  }
  egress_rules = {
    900 = { action = "allow", protocol = "-1", cidr_block = "0.0.0.0/0" },
  }

  tags = {}
}
