variable "resource_group_name" {
  description = "variable of the resource group"
}

variable "location" {
  description = "location of the resource group"
}

variable "suffix" {
  type = string
}

variable "appname" {
  type = string
}

variable "app_service_plan_id" {
  type = string
}


variable "deployment_package_path" {}

variable "common_tags" {
  type    = map(string)
  default = {}
}