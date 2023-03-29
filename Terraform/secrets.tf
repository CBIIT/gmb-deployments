 variable "secret_values" {
  type = map(object({
    secretKey               = string
    secretValue             = map(string)
    description             = string
  }))
}


module "deepmerge" {
  source  = "Invicton-Labs/deepmerge/null"
  maps = [
    local.dynamic_secrets,
    var.secret_values
  ]
}

module "secrets" {
  source                        = "git::https://github.com/CBIIT/datacommons-devops.git//terraform/modules/secrets?ref=v1.0"
  app                           = var.stack_name
  secret_values                 = module.deepmerge.merged
}