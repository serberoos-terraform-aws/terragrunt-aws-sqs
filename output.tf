output "sqs_queue_info" {
  value = try(aws_sqs_queue.this, {})
}

output "sqs_queue_policy_info" {
  value = try(aws_sqs_queue_policy.this, {})
}

output "sqs_queue_redrive_allow_policy_info" {
  value = try(aws_sqs_queue_redrive_allow_policy.this, {})
}

output "sqs_queue_redrive_policy_info" {
  value = try(aws_sqs_queue_redrive_policy.this, {})
} 