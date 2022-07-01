terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.11.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

# ---- create cosmos db  

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }
data "azurerm_cosmosdb_account" "main" {
  name                = "tfex-cosmosdb-account"
  resource_group_name = "tfex-cosmosdb-account-rg"
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "tfex-cosmos-mongo-db"
  resource_group_name = data.azurerm_cosmosdb_account.example.resource_group_name
  account_name        = data.azurerm_cosmosdb_account.example.name
  throughput          = 400
}
  /*geo_location {
    location          = var.cosmos_db_failover_location
    failover_priority = 1
  }*/

  geo_location {
    prefix            = var.cosmos_db_prefix
    location          = var.location
    failover_priority = 0
  }
}
resource "azurerm_log_analytics_cluster" "example" {
  name                = "example-cluster"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  identity {
    type = "SystemAssigned"
  }
}
# Azure Cosmos DB automatically takes a full backup of your database every 4 hours
  # Change the default backup interval and the retention period below 
  backup = {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
  }
  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.mysql.database.azure.com` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Private endpoints doesn't work If using `subnet_id` to create CosmosDB inside a specified VNet.
  enable_private_endpoint       = true
  virtual_network_name          = "RIMS"
  private_subnet_address_prefix = [var.private_ip_allocation]
 
  # Tags for Azure Resources
  {tags = {}
    Terraform   = "true"
    Environment = "dev"
    Owner       = "test-user"
  

  }
