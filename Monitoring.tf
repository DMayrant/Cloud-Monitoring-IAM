resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "my-cloudtrail-logs-bucket ${random_string.random.result}"
  force_destroy = true 
  
  tags = merge(local. common_tags, {
    Name = "CloudTrail Logs Bucket"
  })
  
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_public_access" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_cloudtrail" "main" {
  name                          = "my-cloudtrail-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

    tags = merge(local.common_tags, {
        Name = "CloudTrail Trail"
    })

}

resource "random_string" "random" {
  length  = 10
  special = false
  upper   = false 
  lower   = true  
  numeric = true  

}