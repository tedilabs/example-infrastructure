output "aws_accounts" {
  description = "AWS accounts which used to operate."
  value       = local.accounts
}

output "users" {
  value = {
    # Employees
    "claud" = module.user__claud,
    # Partners
    # Systems
    "terraform" = module.user__terraform,
  }
}

output "groups" {
  value = {
    "administrators" = module.group__administrators,
    "employees"      = module.group__employees,
    "partners"       = module.group__partners,
    "team_devops"    = module.group__team_devops,
    "systems"        = module.group__systems,
  }
}

output "roles" {
  value = {
    "allow-full-access" = module.role__allow_full_access,
    "allow-read-only"   = module.role__allow_read_only,
  }
}
