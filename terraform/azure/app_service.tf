resource azurerm_app_service_plan "example" {
  name                = "terragoat-app-service-plan-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Dynamic"
    size = "S1"
  }
  tags = {
    yor_trace = "ca7c77b6-66e4-42d1-865b-db257c607e09"
    yor_name  = "example"
  }
}

resource azurerm_app_service "app-service1" {
  app_service_plan_id = azurerm_app_service_plan.example.id
  location            = var.location
  name                = "terragoat-app-service-${var.environment}${random_integer.rnd_int.result}"
  resource_group_name = azurerm_resource_group.example.name
  https_only          = false
  site_config {
    min_tls_version = "1.1"
  }
  tags = {
    yor_trace            = "24481597-1ce7-4222-8266-7abe0fc7adb8"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/azure/app_service.tf"
    git_last_modified_at = "2021-05-02 10:06:10"
    git_last_modified_by = "nimrodkor@users.noreply.github.com"
    git_modifiers        = "Adin.Ermie/nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "app-service1"
  }
}

resource azurerm_app_service "app-service2" {
  app_service_plan_id = azurerm_app_service_plan.example.id
  location            = var.location
  name                = "terragoat-app-service-${var.environment}${random_integer.rnd_int.result}"
  resource_group_name = azurerm_resource_group.example.name
  https_only          = true

  auth_settings {
    enabled = false
  }
  tags = {
    yor_trace            = "f8e819a1-eb52-4ba1-a8bb-f683581ccd80"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/azure/app_service.tf"
    git_last_modified_at = "2021-05-02 10:06:10"
    git_last_modified_by = "nimrodkor@users.noreply.github.com"
    git_modifiers        = "Adin.Ermie/nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "app-service2"
  }
}

