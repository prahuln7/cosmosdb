variable "cosmos_db_name" {
  description = "Name of the cosmos db"
}

variable "resource_group_name" {
  description = "Name of the resource group where the storage account belongs"
}

variable "location" {
  description = "Azure region where the storage account will be located"
}

variable "cosmos_db_prefix" {
  description = "cosmos_db_prefix"
}
variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
  
    }