# Terragrunt AWS SQS Module

AWS SQS (Simple Queue Service) 큐를 관리하기 위한 Terraform 모듈입니다.

## 기능

- SQS 큐 생성 및 관리
- SQS 큐 정책 설정
- SQS 리드라이브 정책 설정
- SQS 리드라이브 허용 정책 설정
- FIFO 큐 지원
- KMS 암호화 지원

## 사용법

### 기본 SQS 큐 생성

```hcl
include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "tfr://serberoos-terraform-aws/terragrunt-aws-sqs//?version=1.0.0"
}

inputs = {
  sqs_queue_create = {
    "main-queue" = {
      name = "my-application-queue"
      delay_seconds = 0
      max_message_size = 262144
      message_retention_seconds = 345600
      visibility_timeout_seconds = 30
      sqs_managed_sse_enabled = true
      tags = {
        Environment = "production"
        Project = "my-app"
      }
    }
  }
}
```

### FIFO 큐 생성

```hcl
inputs = {
  sqs_queue_create = {
    "fifo-queue" = {
      name = "my-fifo-queue.fifo"
      fifo_queue = true
      content_based_deduplication = true
      deduplication_scope = "messageGroup"
      fifo_throughput_limit = "perMessageGroupId"
      tags = {
        Environment = "production"
        Type = "fifo"
      }
    }
  }
}
```

### SQS 큐 정책 설정

```hcl
inputs = {
  sqs_queue_create = {
    "main-queue" = {
      name = "my-application-queue"
      # ... 기타 설정
    }
  }
  
  sqs_queue_policy_create = {
    "main-queue-policy" = {
      queue_key = "main-queue"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              AWS = "arn:aws:iam::123456789012:role/my-role"
            }
            Action = [
              "sqs:SendMessage",
              "sqs:ReceiveMessage"
            ]
            Resource = "*"
          }
        ]
      })
    }
  }
}
```

### 리드라이브 정책 설정

```hcl
inputs = {
  sqs_queue_create = {
    "main-queue" = {
      name = "my-application-queue"
      # ... 기타 설정
    }
    "dead-letter-queue" = {
      name = "my-dead-letter-queue"
      # ... 기타 설정
    }
  }
  
  sqs_queue_redrive_policy_create = {
    "main-queue-redrive" = {
      queue_key = "main-queue"
      redrive_policy = jsonencode({
        deadLetterTargetArn = "arn:aws:sqs:us-east-1:123456789012:my-dead-letter-queue"
        maxReceiveCount = 3
      })
    }
  }
}
```

## 변수

### sqs_queue_create

SQS 큐 생성 설정

| 변수명 | 타입 | 기본값 | 설명 |
|--------|------|--------|------|
| name | string | - | 큐 이름 (필수) |
| delay_seconds | number | 0 | 메시지 지연 시간 (초) |
| max_message_size | number | 262144 | 최대 메시지 크기 (바이트) |
| message_retention_seconds | number | 345600 | 메시지 보관 시간 (초) |
| receive_wait_time_seconds | number | 0 | 수신 대기 시간 (초) |
| visibility_timeout_seconds | number | 30 | 가시성 타임아웃 (초) |
| fifo_queue | bool | false | FIFO 큐 여부 |
| content_based_deduplication | bool | false | 내용 기반 중복 제거 |
| deduplication_scope | string | null | 중복 제거 범위 |
| fifo_throughput_limit | string | null | FIFO 처리량 제한 |
| redrive_policy | string | null | 리드라이브 정책 |
| redrive_allow_policy | string | null | 리드라이브 허용 정책 |
| sqs_managed_sse_enabled | bool | true | SQS 관리 SSE 활성화 |
| kms_master_key_id | string | null | KMS 마스터 키 ID |
| kms_data_key_reuse_period_seconds | number | 300 | KMS 데이터 키 재사용 기간 |
| tags | map | {} | 태그 |

### sqs_queue_policy_create

SQS 큐 정책 설정

| 변수명 | 타입 | 설명 |
|--------|------|------|
| queue_key | string | 정책을 적용할 큐의 키 |
| policy | string | JSON 형태의 정책 |

### sqs_queue_redrive_policy_create

SQS 리드라이브 정책 설정

| 변수명 | 타입 | 설명 |
|--------|------|------|
| queue_key | string | 정책을 적용할 큐의 키 |
| redrive_policy | string | JSON 형태의 리드라이브 정책 |

### sqs_queue_redrive_allow_policy_create

SQS 리드라이브 허용 정책 설정

| 변수명 | 타입 | 설명 |
|--------|------|------|
| queue_key | string | 정책을 적용할 큐의 키 |
| redrive_allow_policy | string | JSON 형태의 리드라이브 허용 정책 |

## 출력

### sqs_queue_info

생성된 SQS 큐 정보

### sqs_queue_policy_info

생성된 SQS 큐 정책 정보

### sqs_queue_redrive_policy_info

생성된 SQS 리드라이브 정책 정보

### sqs_queue_redrive_allow_policy_info

생성된 SQS 리드라이브 허용 정책 정보

## 예시

```hcl
# 출력 사용 예시
output "queue_url" {
  value = module.sqs.sqs_queue_info["main-queue"].url
}

output "queue_arn" {
  value = module.sqs.sqs_queue_info["main-queue"].arn
}
```

## 라이선스

MIT License
