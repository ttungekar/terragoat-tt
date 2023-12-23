resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "881ca790-ba9c-45d6-b305-25cbad0b4636"
    yor_name  = "example"
  }
}