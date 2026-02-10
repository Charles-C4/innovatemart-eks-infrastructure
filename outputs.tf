output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "region" {
  description = "AWS region"
  value       = "us-east-1"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "The name of the S3 bucket for assets"
  value       = aws_s3_bucket.assets.id
}

# Credentials for the bedrock-dev-view user (Requirement 4.3 & 6)
output "dev_view_access_key_id" {
  description = "Access Key ID for the developer view user"
  value       = aws_iam_access_key.dev_view.id
}

output "dev_view_secret_key" {
  description = "Secret Access Key for the developer view user"
  value       = aws_iam_access_key.dev_view.secret
  sensitive   = true
}