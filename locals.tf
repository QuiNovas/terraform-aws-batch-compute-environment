locals {
  network_resources_needed = length(var.subnets) == 0 ? true : false
  subnets_count            = length(var.availability_zones) > 2 ? 3 : 2

  private_subnets = local.subnets_count == 3 ? [
    cidrsubnet(var.cidr_block, 4, 3),
    cidrsubnet(var.cidr_block, 4, 4),
    cidrsubnet(var.cidr_block, 4, 5)] : [
    cidrsubnet(var.cidr_block, 4, 2),
    cidrsubnet(var.cidr_block, 4, 3)
  ]

  public_subnets = local.subnets_count == 3 ? [
    cidrsubnet(var.cidr_block, 4, 0),
    cidrsubnet(var.cidr_block, 4, 1),
    cidrsubnet(var.cidr_block, 4, 2)] : [
    cidrsubnet(var.cidr_block, 4, 0),
    cidrsubnet(var.cidr_block, 4, 1)
  ]
}