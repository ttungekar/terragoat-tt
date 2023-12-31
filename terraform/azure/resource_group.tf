resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "5bc9286b-7959-4cb7-a15b-81a747df1963"
  }
}