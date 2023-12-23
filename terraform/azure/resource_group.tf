resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "60290007-7fe8-4931-a727-133340cd91f9"
    yor_name  = "example"
  }
}