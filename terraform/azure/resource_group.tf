resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "acb104d7-d08a-4d18-bf5b-681fe453dadf"
  }
}