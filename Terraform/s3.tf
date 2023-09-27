module "s3" {
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3"
  resource_prefix     = "${var.project}-${terraform.workspace}"
  bucket_name = local.alb_log_bucket_name
  stack_name = var.stack_name
  env = terraform.workspace
  tags = var.tags
  s3_force_destroy = var.s3_force_destroy
  days_for_archive_tiering = 125
  days_for_deep_archive_tiering = 180
  s3_enable_access_logging = false
  s3_access_log_bucket_id = ""
}

module "s3-replication-source" {
  count = var.create_s3_replication ? 1 : 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3-replication-source"
  resource_prefix     = "${var.project}-${terraform.workspace}"
  destination_bucket_name = var.destination_bucket_name 
  env =  terraform.workspace
  source_bucket_name = var.source_bucket_name
  stack_name = var.stack_name
  tags = var.tags
  target_account_cloudone = var.target_account_cloudone
  create_source_bucket = var.create_source_bucket 
  replication_destination_account_id = var.replication_destination_account_id
}

module "s3-replication-destination" {
  count = var.enable_s3_replication ? 1 : 0
  source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/s3-replication-destination"
  destination_bucket_name = var.destination_bucket_name 
  tags = var.tags
  replication_role_arn = var.replication_role_arn
  create_destination_bucket = var.create_destination_bucket
}

resource "aws_s3_bucket_policy" "alb_bucket_policy" {
  bucket = module.s3.bucket_id
  policy = data.aws_iam_policy_document.s3_alb_policy.json
}