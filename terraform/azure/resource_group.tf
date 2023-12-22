resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "41bd7a6f-1f26-47e5-bc64-a60ec21c974b"
    yor_name  = "example"
  }
}