output "config" {
  value = local.config
}

output "delegation_sets" {
  value = aws_route53_delegation_set.this
}

output "public_zones" {
  value = {
    primary   = module.public_zone__primary,
    secondary = module.public_zone__secondary,
  }
}

output "private_zones" {
  value = module.private_zone
}

output "amazon_certs" {
  value = module.amazon_cert
}
