resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "91a8e835-ca95-4c4d-8999-9894a95194ea"
  }
}