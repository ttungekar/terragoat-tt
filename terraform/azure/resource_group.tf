resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "9c02d535-3673-4560-ac4e-f27a6e9b4df3"
    yor_name  = "example"
  }
}