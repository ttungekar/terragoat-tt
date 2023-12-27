resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "23aaf3a0-a6b5-4716-badd-7ae54cb6e022"
    yor_name  = "example"
  }
}