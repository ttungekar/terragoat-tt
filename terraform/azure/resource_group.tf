resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "81c741d4-bc6e-40b1-b3db-a135b3d741aa"
    yor_name  = "example"
  }
}