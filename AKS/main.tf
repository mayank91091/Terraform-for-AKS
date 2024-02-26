resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "my_resource_group" // Static name for the resource group
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "my_kubernetes_cluster" // Static name for the Kubernetes cluster
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "my_dns_prefix" // Static DNS prefix for the Kubernetes cluster

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2s_v3"
    node_count = var.node_count
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
