variable "resource_group_name" {
  description = "variable of the resource group"
}

variable "location" {
  description = "location of the resource group"
}

variable "suffix" {
  type = string
}

variable "appsvcplan_sku_tier" {
  type        = string
  description = "Size of the app service plan Eg: Standard, Premium"
  default     = "Basic"
}

variable "appsvcplan_sku_size" {
  type        = string
  description = "Size of the app service plan Eg: S1,S2"
  default     = "B1"
}

variable "appsvcplan_sku_capacity" {
  description = "Count of number of instances for the app service plan Eg: 1,2"
  default     = 1
}

variable "appsvcplan_kind" {
  description = "Windows or Dynamic"
  default     = "Windows"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}