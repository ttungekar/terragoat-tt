resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "ee1206ab-f401-42a7-ae68-9a4106cc1335"
    yor_name  = "example"
  }
}