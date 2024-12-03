provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
}

variable "subscription_id" {
    description = "The Azure subscription ID"
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}

variable "location" {
    description = "The location of the resource group"
    type        = string
    default     = "East US"
}

resource "azurerm_resource_group" "myResourceGroup" {
    name     = var.resource_group_name
    location = var.location
}