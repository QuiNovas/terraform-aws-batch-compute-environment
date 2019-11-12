output "compute_environment_arn" {
  description = "The arn of the batch compute environment"
  value       = aws_batch_compute_environment.compute_environment.arn
}

output "vpc_id" {
  value = "${join("", aws_vpc.vpc.*.id)}"
}

output "public_subnet_ids" {
  value = "${join("", aws_subnet.public.*.id)}"
}

output "batch_service_role_arn" {
  value = "${join("", aws_iam_role.aws_batch_service_role.*.arn)}"
}

output "ecs_instance_role_arn" {
  value = "${join("", aws_iam_role.ecs_instance_role.*.arn)}"
}

output "ecs_instance_profile_arn" {
  value = "${join("", aws_iam_role.ecs_instance_role.*.arn)}"
}

output "spot_fleet_role_arn" {
  value = "${join("", aws_iam_role.spot_fleet_role.*.arn)}"
}

output "compute_environment_ecs_cluster_arn" {
  value = aws_batch_compute_environment.compute_environment.ecs_cluster_arn
}
