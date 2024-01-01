resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "9968e4a9-303d-4001-960a-99cd3028f59e"
    yor_name  = "example"
  }
}