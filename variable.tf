variable "sqs_queue_create" {
  description = "Defined sqs_queue_create Information"
  type        = map(any)
  default     = {}
}

variable "sqs_queue_policy_create" {
  description = "Defined sqs_queue_policy_create Information"
  type        = map(any)
  default     = {}
}

variable "sqs_queue_redrive_allow_policy_create" {
  description = "Defined sqs_queue_redrive_allow_policy_create Information"
  type        = map(any)
  default     = {}
}

variable "sqs_queue_redrive_policy_create" {
  description = "Defined sqs_queue_redrive_policy_create Information"
  type        = map(any)
  default     = {}
} 