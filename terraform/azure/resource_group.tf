resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "990c31df-4d20-4be5-b2bc-97b66b1f2ba3"
  }
}