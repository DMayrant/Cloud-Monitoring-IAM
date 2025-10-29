resource "aws_iam_role" "aurora_connect_role" {
  name        = "aurora-postgresql-connect-role"
  description = "IAM role for Aurora PostgreSQL to allow IAM database authentication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "aurora_postgresql_connect_policy" {
  name        = "aurora-postgresql-connect-policy"
  description = "Policy allowing connection to Aurora PostgreSQL"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["rds-db:connect"]
      Resource = [
        "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster.aurora_postgresql.cluster_identifier}/${var.db_username}"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_aurora_policy" {
  role       = aws_iam_role.aurora_connect_role.name
  policy_arn = aws_iam_policy.aurora_postgresql_connect_policy.arn
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Enforces users to use their MFA devices 
resource "aws_iam_policy" "enforce_mfa_policy" {
  name        = "EnforceMFA"
  description = "Policy to enforce MFA for sensitive actions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = [
          "iam:*",
          "ec2:TerminateInstances",
          // Add other sensitive actions
        ],
        Resource = "*",
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_mfa_policy" {
  user       = data.aws_iam_user.example.user_name
  policy_arn = aws_iam_policy.enforce_mfa_policy.arn
}

data "aws_iam_user" "example" {
  user_name = "devonne"
}

resource "aws_sns_topic" "sns_topic" {
  name         = "my-example-sns-topic"
  display_name = "Notification SNS Topic"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "SNS:Publish",
          "SNS:Subscribe"
        ],
        Resource = "arn:aws:sns:us-east-1:123456789012:my-example-sns-topic"
      }
    ]
  })
}
