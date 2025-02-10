terraform {
  source = "../../../modules/glue-job"
}

inputs = {
  bucket_name = "chirantanterragrunt-bucket22"
  region      = "ap-south-1"
}