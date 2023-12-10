resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "068638ac-077c-4505-9a1b-92570d6fb99b"
    yor_name  = "example"
  }
}