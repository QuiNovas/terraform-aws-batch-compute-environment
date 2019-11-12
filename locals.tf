locals {
  public_subnets_count = var.availability_zones_count > 2 ? 3 : 2
  public_subnets = local.public_subnets_count == 3 ? [
    cidrsubnet(var.cidr_block, 4, 0),
    cidrsubnet(var.cidr_block, 4, 1),
    cidrsubnet(var.cidr_block, 4, 2)] : [
    cidrsubnet(var.cidr_block, 4, 0),
    cidrsubnet(var.cidr_block, 4, 1)
  ]
  network_resources_needed = length(var.subnets) == 0 ? true : false
}