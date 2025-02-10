variable "bucket_name" {
  description = "Name of the S3 bucket for job output"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}