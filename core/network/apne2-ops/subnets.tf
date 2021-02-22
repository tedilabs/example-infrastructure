###################################################
# App Subnets
###################################################

module "subnet_group__app_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/subnet-group"
  version = "0.8.0"

  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  subnets = {
    for idx, subnet in local.config.subnet_groups.app_private:
      "${module.vpc.name}-app-private-${format("%03d", idx + 1)}/${subnet.az_id}" => {
        cidr_block           = subnet.cidr,
        availability_zone_id = subnet.az_id,
      }
  }

  tags = {}
}


###################################################
# Data Subnets
###################################################

module "subnet_group__data_private_managed" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/subnet-group"
  version = "0.8.0"

  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  db_subnet_group_enabled    = true
  db_subnet_group_name       = "${local.config.vpc.name}-db-private"
  cache_subnet_group_enabled = true
  cache_subnet_group_name    = "${local.config.vpc.name}-cache-private"

  subnets = {
    for idx, subnet in local.config.subnet_groups.data_private_managed:
      "${module.vpc.name}-data-private-managed-${format("%03d", idx + 1)}/${subnet.az_id}" => {
        cidr_block           = subnet.cidr,
        availability_zone_id = subnet.az_id,
      }
  }

  tags = {}
}

module "subnet_group__data_private_self" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/subnet-group"
  version = "0.8.0"

  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  subnets = {
    for idx, subnet in local.config.subnet_groups.data_private_self:
      "${module.vpc.name}-data-private-self-${format("%03d", idx + 1)}/${subnet.az_id}" => {
        cidr_block           = subnet.cidr,
        availability_zone_id = subnet.az_id,
      }
  }

  tags = {}
}


###################################################
# Network Subnets
###################################################

module "subnet_group__net_private" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/subnet-group"
  version = "0.8.0"

  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = false

  subnets = {
    for idx, subnet in local.config.subnet_groups.net_private:
      "${module.vpc.name}-net-private-${format("%03d", idx + 1)}/${subnet.az_id}" => {
        cidr_block           = subnet.cidr,
        availability_zone_id = subnet.az_id,
      }
  }

  tags = {}
}

module "subnet_group__net_public" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/subnet-group"
  version = "0.8.0"

  vpc_id                  = module.vpc.id
  map_public_ip_on_launch = true

  subnets = {
    for idx, subnet in local.config.subnet_groups.net_public:
      "${module.vpc.name}-net-public-${format("%03d", idx + 1)}/${subnet.az_id}" => {
        cidr_block           = subnet.cidr,
        availability_zone_id = subnet.az_id,
      }
  }

  tags = {}
}
