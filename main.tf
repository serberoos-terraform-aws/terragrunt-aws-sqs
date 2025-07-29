resource "aws_sqs_queue" "this" {
  for_each = var.sqs_queue_create

  name = each.value.name

  delay_seconds = lookup(each.value, "delay_seconds", 0)
  max_message_size = lookup(each.value, "max_message_size", 262144)
  message_retention_seconds = lookup(each.value, "message_retention_seconds", 345600)
  receive_wait_time_seconds = lookup(each.value, "receive_wait_time_seconds", 0)
  visibility_timeout_seconds = lookup(each.value, "visibility_timeout_seconds", 30)

  fifo_queue = lookup(each.value, "fifo_queue", false)
  content_based_deduplication = lookup(each.value, "content_based_deduplication", false)
  deduplication_scope = lookup(each.value, "deduplication_scope", null)
  fifo_throughput_limit = lookup(each.value, "fifo_throughput_limit", null)

  redrive_policy = lookup(each.value, "redrive_policy", null)
  redrive_allow_policy = lookup(each.value, "redrive_allow_policy", null)

  sqs_managed_sse_enabled = lookup(each.value, "sqs_managed_sse_enabled", true)
  kms_master_key_id = lookup(each.value, "kms_master_key_id", null)
  kms_data_key_reuse_period_seconds = lookup(each.value, "kms_data_key_reuse_period_seconds", 300)

  tags = merge(
    {
      Name = each.value.name
      Type = "sqs-queue"
    },
    lookup(each.value, "tags", {})
  )
}

resource "aws_sqs_queue_policy" "this" {
  for_each = var.sqs_queue_policy_create

  queue_url = aws_sqs_queue.this[each.value.queue_key].url
  policy    = each.value.policy
}

resource "aws_sqs_queue_redrive_allow_policy" "this" {
  for_each = var.sqs_queue_redrive_allow_policy_create

  queue_url = aws_sqs_queue.this[each.value.queue_key].url
  redrive_allow_policy = each.value.redrive_allow_policy
}

resource "aws_sqs_queue_redrive_policy" "this" {
  for_each = var.sqs_queue_redrive_policy_create

  queue_url = aws_sqs_queue.this[each.value.queue_key].url
  redrive_policy = each.value.redrive_policy
} 