resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "ba551fcf-151d-42b7-886c-958a093b0ee0"
  }
}