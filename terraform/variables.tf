variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "adarsh-demo-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
