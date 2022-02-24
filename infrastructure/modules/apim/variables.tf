variable "resource_group_name" {
  description = "variable of the resource group"
}

variable "location" {
  description = "location of the resource group"
}

variable "publisher_email" {
  default = "test@gmail.com"
}
variable "suffix" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
