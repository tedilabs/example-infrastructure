locals {
  private_zones = local.remote_states.domain.private_zones
}

module "vpc" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/vpc"
  version = "0.8.0"

  name                  = local.config.vpc.name
  cidr_block            = local.config.vpc.cidr
  secondary_cidr_blocks = local.config.vpc.secondary_cidrs
  ipv6_enabled          = false

  internet_gateway_enabled             = true
  egress_only_internet_gateway_enabled = false

  vpn_gateway_enabled = true
  vpn_gateway_asn     = 64800

  dns_hostnames_enabled = true
  dns_support_enabled   = true
  private_hosted_zones  = [
    local.private_zones["tedilabs.local"].id,
    local.private_zones["dev.tedilabs.local"].id,
  ]

  dhcp_options_enabled = true

  tags = {}
}
