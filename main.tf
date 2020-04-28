resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
      tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_postgresql_server" "example" {
  name                = "pgrsql-srvr-toes2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "B_Gen5_2"

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = var.gebruikersnaam
  administrator_login_password = var.wachtwoord
  version                      = "9.5"
  ssl_enforcement              = "Enabled"

  tags = {
    environment = "${var.omgeving}"
}

resource "azurerm_postgresql_database" "example" {
  name                = "db-toes2"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.example.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
  
  tags = {
    environment = "${var.omgeving}"
}