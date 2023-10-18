module "ecr" {
   count = var.create_ecr_repos ? 1: 0
   source = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/ecr?ref=v1.3"
   resource_prefix     = "${var.stack_name}-${terraform.workspace}"
   project = var.stack_name 
   ecr_repo_names = var.ecr_repo_names
   tags = var.tags
   #create_env_specific_repo = var.create_env_specific_repo
   env = terraform.workspace
   enable_ecr_replication = var.enable_ecr_replication
   replication_destination_registry_id = var.replication_destination_registry_id
   replication_source_registry_id = var.replication_source_registry_id 
   allow_ecr_replication = var.allow_ecr_replication
}
