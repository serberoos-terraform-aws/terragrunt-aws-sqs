output "sqs_queue_info" {
  description = "Module output for sqs queue information"
  value       = try(aws_sqs_queue.this, {})
}

output "sqs_queue_policy_info" {
  description = "Module output for sqs queue policy information"
  value       = try(aws_sqs_queue_policy.this, {})
}

output "sqs_queue_redrive_allow_policy_info" {
  description = "Module output for sqs queue redrive allow policy information"
  value       = try(aws_sqs_queue_redrive_allow_policy.this, {})
}

output "sqs_queue_redrive_policy_info" {
  description = "Module output for sqs queue redrive policy information"
  value       = try(aws_sqs_queue_redrive_policy.this, {})
} 