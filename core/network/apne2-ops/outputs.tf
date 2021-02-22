output "config" {
  value = local.config
}

output "vpc" {
  value = module.vpc
}

output "subnet_groups" {
  value = {
    "app-private" = module.subnet_group__app_private,
  }
}

output "eip" {
  value = {
    for name, eip in aws_eip.claud:
      name => eip.public_ip
  }
}

output "nat_gateway" {
  value = module.nat_gw
}

output "security_groups" {
  value = {
    "ssh-gateway" = module.sg__ssh_gateway,
    "ssh-target"  = module.sg__ssh_target,
    "icmp"        = module.sg__icmp,
  }
}
