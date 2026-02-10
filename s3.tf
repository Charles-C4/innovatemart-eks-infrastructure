resource "aws_s3_bucket" "assets" {
  # Requirement: bedrock-assets-[your-student-id]
  # Sanitized: Slashes replaced with hyphens, trailing dot removed, and all lowercase
  bucket = "bedrock-assets-alt-soe-025-1379" 

  tags = {
    Project = "Bedrock"
    force_destroy = "true"
  }
}

# 1. Ensure the bucket is private (Requirement 4.5)
resource "aws_s3_bucket_public_access_block" "assets_access" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  
}

# 2. Add Versioning (Best practice for Assets)
resource "aws_s3_bucket_versioning" "assets_versioning" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration {
    status = "Enabled"
  }
}