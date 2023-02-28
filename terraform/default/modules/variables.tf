# ------------------------- #
# ------ module vars ------ #
# ------------------------- #

variable "name" {
  default     = "dev"
  description = "The overarching name of this deployment (not just the lambdas therein)"
  type        = string
  nullable    = false
}

variable "image" {
  default = "828365799633.dkr.ecr.eu-west-2.amazonaws.com/jmeter-load-test:1.0.0"
  description = "ECR URL for docker image"
}


# create the local config objects for this module
# by pulling in the tfvars file (as it doesn't get read automatically in child modules)
# then doing a deep merge of the module and target vars using the below function

locals {
  tfvars = jsondecode(file("${path.module}/terraform.tfvars.json"))
  module_config = try(local.tfvars.config, {})
  module_env_vars = try(local.tfvars.env_vars, {})
}

module "merge_config" {
  source  = "Invicton-Labs/deepmerge/null"
  maps = [local.module_config, var.target_config]
}
module "merge_envvars" {
  source  = "Invicton-Labs/deepmerge/null"
  maps = [local.module_env_vars, var.target_envvars]
}

locals {
  config  = module.merge_config.merged
  env_vars = module.merge_envvars.merged
}


# ------------------------ #
# ------ core vars ------- #
# ------------------------ #

variable "env" {
  description = "The environment being deployed to, e.g. uat, production, local"
  type        = string
  nullable    = false
}

variable "vrsn" {
  description = "The version of this particular deployment"
  type        = string
  nullable    = false
}

variable "target_config" {
  default     = {}
  description = "A catchall map of all variables from the target module"
  type        = any
}

variable "target_envvars" {
  default     = {}
  description = "A catchall map of all enviroment variables from the target module"
  type        = any
}
variable "container_port" {
  default = 80
}
variable "environment" {
  default = "dev"
}