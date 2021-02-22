locals {
  remote_states = {
    domain = data.terraform_remote_state.domain.outputs,
  }
}


###################################################
# Terraform Remote States (External Dependencies)
###################################################

data "terraform_remote_state" "domain" {
  backend = "remote"

  config = {
    organization = "example"
    workspaces = {
      name = "example-aws-domain"
    }
  }
}
