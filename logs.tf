#
#S3 Bucket for logs 
#
resource "aws_s3_bucket" "s3-logs" {
  bucket = "cloud-ctf-logs"

  tags = {
    Name    = "cloud-ctf-logs"
    Project = "cloud-ctf"
  }
}

resource "aws_s3_bucket_versioning" "s3-logs-versioning" {
  bucket = aws_s3_bucket.s3-logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-logs-sse" {
  bucket = aws_s3_bucket.s3-logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-logs-publicaccess" {
  bucket = aws_s3_bucket.s3-logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#
# CloudTrail
#

resource "aws_cloudtrail" "cloud_ctf" {
  name                          = "cloud-ctf-trail"
  s3_bucket_name                = aws_s3_bucket.s3-logs.id
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = {
    Project = "cloud-ctf"
  }
}
