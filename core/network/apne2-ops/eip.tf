resource "aws_eip" "claud" {
  for_each = toset(local.config.eip)

  tags = {
    "Name" = each.value
  }
}
