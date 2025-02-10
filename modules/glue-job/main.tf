provider "aws" {
  region = var.region
}

resource "aws_s3_object" "glue_script" {
  bucket       = var.bucket_name  # Reference the S3 bucket
  key          = "scripts/my-script.py"                   # Destination path in the bucket
  source       = "my-script.py"                           # Local file path
  content_type = "text/x-python"
  acl          = "private"
}

# Create an IAM Role for Glue Job
resource "aws_iam_role" "glue_role" {
  name = "glue-job-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Grant full access to S3 (adjust as needed)
}

# Create the Glue Job
resource "aws_glue_job" "my_job" {
  name     = "sample-chirantan-glue-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.bucket_name}/scripts/my-script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir" = "s3://${var.bucket_name}/temp/"
    "--job-bookmark-option" = "job-bookmark-enable"
  }

  max_retries     = 2
  timeout         = 10
  glue_version    = "2.0"
  worker_type     = "Standard"
  number_of_workers = 2
}
