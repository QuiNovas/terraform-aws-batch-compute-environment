resource "aws_batch_compute_environment" "compute_environment" {
  compute_environment_name = "${var.compute_environment_name}"

  compute_resources {
    bid_percentage = var.compute_resources_type == "SPOT" ? var.bid_percentage : null
    desired_vcpus  = var.desired_vcpus
    ec2_key_pair   = var.ec2_key_pair
    image_id       = var.image_id
    instance_role  = var.instance_role == "" ? aws_iam_instance_profile.ecs_instance_role.0.arn : var.instance_role
    instance_type  = var.instance_type

    dynamic "launch_template" {
      for_each = var.launch_template
      content {
        launch_template_id = launch_template.value.launch_template_id
        version            = launch_template.value.version
      }
    }

    max_vcpus           = var.max_vcpus
    min_vcpus           = var.min_vcpus
    security_group_ids  = var.security_group_ids
    spot_iam_fleet_role = var.compute_resources_type != "SPOT" ? null : var.spot_iam_fleet_role == "" ? aws_iam_role.spot_fleet_role.0.arn : var.spot_iam_fleet_role
    subnets             = var.subnets
    type                = var.compute_resources_type
  }

  service_role = var.service_role == "" ? aws_iam_role.aws_batch_service_role.0.arn : var.service_role
  state        = var.state
  type         = var.type
}