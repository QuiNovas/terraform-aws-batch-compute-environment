resource "random_shuffle" "az" {
  input        = var.availability_zones
  result_count = local.subnets_count
}

resource "aws_vpc" "vpc" {
  count      = local.network_resources_needed ? 1 : 0
  cidr_block = var.cidr_block
  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "igw" {
  count  = local.network_resources_needed ? 1 : 0
  vpc_id = aws_vpc.vpc.0.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count = local.network_resources_needed ? local.subnets_count : 0

  vpc_id            = aws_vpc.vpc.0.id
  cidr_block        = local.public_subnets[count.index]
  availability_zone = element(random_shuffle.az.result, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-public-%s",
        var.name,
        element(random_shuffle.az.result, count.index),
      )
    },
    var.tags,
  )
}

resource "aws_subnet" "private" {
  count = local.network_resources_needed ? local.subnets_count : 0

  vpc_id            = aws_vpc.vpc.0.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = element(random_shuffle.az.result, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-private-%s",
        var.name,
        element(random_shuffle.az.result, count.index),
      )
    },
    var.tags,
  )
}

resource "aws_route_table" "public" {
  count = local.network_resources_needed ? 1 : 0

  vpc_id = aws_vpc.vpc.0.id

  tags = merge(
    {
      "Name" = format("%s-public", var.name)
    },
    var.tags
  )

}

resource "aws_route" "public_internet_gateway" {
  count = local.network_resources_needed ? 1 : 0

  route_table_id         = aws_route_table.public.0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.0.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = local.network_resources_needed ? local.subnets_count : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.0.id
}

resource "aws_eip" "nat" {
  count = local.network_resources_needed ? local.subnets_count : 0

  vpc = true

  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(random_shuffle.az.result, count.index),
      )
    },
    var.tags
  )
}

resource "aws_nat_gateway" "ngw" {
  count = local.network_resources_needed ? local.subnets_count : 0

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)


  tags = merge(
    {
      "Name" = format(
        "%s-%s",
        var.name,
        element(random_shuffle.az.result, count.index),
      )
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private_nat_gateway" {
  count = local.network_resources_needed ? local.subnets_count : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "private" {
  count = local.network_resources_needed ? local.subnets_count : 0

  vpc_id = aws_vpc.vpc.0.id

  tags = merge(
    {
      "Name" = format(
        "%s-private-%s",
        var.name,
        element(random_shuffle.az.result, count.index),
      )
    },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  count = local.network_resources_needed ? local.subnets_count : 0

  subnet_id = element(aws_subnet.private.*.id, count.index)

  route_table_id = element(
    aws_route_table.private.*.id,
    count.index
  )
}

resource "aws_security_group" "base_sg" {
  count = local.network_resources_needed ? 1 : 0

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  name   = var.name
  vpc_id = aws_vpc.vpc.0.id

  tags = {
    Name = var.name
  }
}
