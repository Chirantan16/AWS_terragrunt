terraform {
  source = "../../../modules/s3-bucket"
}

inputs = {
  bucket_name = "chirantanterragrunt-bucket22"
  region      = "ap-south-1"
}