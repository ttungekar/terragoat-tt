resource "azurerm_virtual_network" "example" {
  name                = "terragoat-vn-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "89691b39-6a57-4afd-b864-a96cae66009f"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "terragoat-${var.environment}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "ni_linux" {
  name                = "terragoat-linux-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "d86605a7-b67a-4cc7-b46d-1063ae0c1dcf"
  }
}

resource "azurerm_network_interface" "ni_win" {
  name                = "terragoat-win-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "5e163f47-9e79-49ff-9c48-b230c480aa5f"
  }
}

resource azurerm_network_security_group "bad_sg" {
  location            = var.location
  name                = "terragoat-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 200
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "22-22"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 300
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "3389-3389"
    destination_address_prefix = "*"
  }
  tags = {
    yor_trace = "e53ca8a5-380c-4bad-88b3-745157cf704c"
  }
}

resource azurerm_network_watcher "network_watcher" {
  location            = var.location
  name                = "terragoat-network-watcher-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "41c75c48-f6bd-4fb1-9560-c156f4b3eaac"
  }
}

resource azurerm_network_watcher_flow_log "flow_log" {
  enabled                   = false
  network_security_group_id = azurerm_network_security_group.bad_sg.id
  network_watcher_name      = azurerm_network_watcher.network_watcher.name
  resource_group_name       = azurerm_resource_group.example.name
  storage_account_id        = azurerm_storage_account.example.id
  retention_policy {
    enabled = false
    days    = 10
  }
  tags = {
    yor_trace = "6254f579-2168-4516-9486-4746e0836c17"
  }
}