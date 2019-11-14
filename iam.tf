resource "aws_iam_role" "aws_batch_service_role" {
  count = var.service_role == "" ? 1 : 0
  name  = "${var.name}-aws-batch-service-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  count      = var.service_role == "" ? 1 : 0
  role       = aws_iam_role.aws_batch_service_role.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role" "ecs_instance_role" {
  count = var.instance_role == "" ? 1 : 0
  name  = "${var.name}-ecs-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  count      = var.instance_role == "" ? 1 : 0
  role       = aws_iam_role.ecs_instance_role.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  count = var.instance_role == "" ? 1 : 0
  name  = "${var.name}-ecs-instance-role"
  role  = aws_iam_role.ecs_instance_role.0.name
}

resource "aws_iam_role" "spot_fleet_role" {
  count = var.spot_iam_fleet_role == "" && var.compute_resources_type == "SPOT" ? 1 : 0
  name  = "${var.name}-spot-fleet-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "spotfleet.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "spot_fleet_role" {
  count      = var.spot_iam_fleet_role == "" && var.compute_resources_type == "SPOT" ? 1 : 0
  role       = aws_iam_role.spot_fleet_role.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}