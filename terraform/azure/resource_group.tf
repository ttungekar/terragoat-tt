resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "9cbf57fe-15a9-46e6-b79d-8d6b1b93eb9d"
  }
}