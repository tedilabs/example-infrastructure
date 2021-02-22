resource "aws_default_security_group" "this" {
  vpc_id = module.vpc.id

  tags = {
    "Name" = "${module.vpc.name}-default"
  }
}


###################################################
# Security Groups for SSH
###################################################

module "sg__ssh_gateway" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/security-group"
  version = "0.8.0"

  name        = "${module.vpc.name}-ssh-gateway"
  description = "Security Group for SSH gateway nodes."
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      protocol = "tcp",
      from_port = 22,
      to_port = 22,
      cidr_blocks = ["0.0.0.0/0"],
      description = "Allow SSH from anywhere."
    },
  ]
  egress_rules = [
  ]

  tags = {}
}

module "sg__ssh_target" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/security-group"
  version = "0.8.0"

  name        = "${module.vpc.name}-ssh-target"
  description = "Security Group for SSH target nodes."
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      protocol = "tcp",
      from_port = 22,
      to_port = 22,
      source_security_group_id = module.sg__ssh_gateway.id,
      description = "Allow SSH from gateway to target."
    },
    {
      protocol = "tcp",
      from_port = 22,
      to_port = 22,
      self = true,
      description = "Allow SSH from each members of the Security Group."
    },
  ]
  egress_rules = [
  ]

  tags = {}
}


###################################################
# Security Groups for ICMP
###################################################

module "sg__icmp" {
  source  = "app.terraform.io/tedilabs/network/aws//modules/security-group"
  version = "0.8.0"

  name        = "${module.vpc.name}-icmp"
  description = "Security Group for ICMP communications."
  vpc_id      = module.vpc.id

  ingress_rules = [
    {
      protocol = "icmp",
      from_port = -1,
      to_port = -1,
      cidr_blocks = [module.vpc.cidr_block],
      description = "Allow ICMP from VPC CIDR."
    },
    {
      protocol = "icmp",
      from_port = -1,
      to_port = -1,
      self = true,
      description = "Allow ICMP from each members of the Security Group."
    },
  ]
  egress_rules = [
  ]

  tags = {}
}
