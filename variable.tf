variable "sqs_queue_create" {
  type    = map(any)
  default = {}
}

variable "sqs_queue_policy_create" {
  type    = map(any)
  default = {}
}

variable "sqs_queue_redrive_allow_policy_create" {
  type    = map(any)
  default = {}
}

variable "sqs_queue_redrive_policy_create" {
  type    = map(any)
  default = {}
} 