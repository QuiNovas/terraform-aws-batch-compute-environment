output "arn" {
  description = "The arn of the batch compute environment"
  value       = aws_batch_compute_environment.compute_environment.arn
}

output "batch_service_role_arn" {
  value = join("", aws_iam_role.aws_batch_service_role.*.arn)
}

output "batch_service_role_arn" {
  value = join("", aws_iam_role.aws_batch_service_role.*.arn)
}


output "ecs_cluster_arn" {
  value = aws_batch_compute_environment.compute_environment.ecs_cluster_arn
}

output "ecs_instance_profile_arn" {
  value = join("", aws_iam_role.ecs_instance_role.*.arn)
}

output "ecs_instance_role_arn" {
  value = join("", aws_iam_role.ecs_instance_role.*.arn)
}

output "public_subnet_ids" {
  value = join("", aws_subnet.public.*.id)
}

output "private_subnet_ids" {
  value = join("", aws_subnet.private.*.id)
}

output "security_group_id" {
  value = join("", aws_security_group.base_sg.*.id)
}

output "spot_fleet_role_arn" {
  value = join("", aws_iam_role.spot_fleet_role.*.arn)
}

output "status" {
  description = "The current status of the compute environment (for example, CREATING or VALID)."
  value       = aws_batch_compute_environment.compute_environment.status
}

output "status_reason" {
  description = "A short, human-readable string to provide additional details about the current status of the compute environment"
  value       = aws_batch_compute_environment.compute_environment.status_reason
}

output "vpc_id" {
  value = join("", aws_vpc.vpc.*.id)
}