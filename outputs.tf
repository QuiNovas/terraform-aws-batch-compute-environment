output "arn" {
  description = "The arn of the batch compute environment"
  value       = aws_batch_compute_environment.compute_environment.arn
}
