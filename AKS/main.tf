resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "myResourceGroup"  # Manually specify the resource group name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "myAKSCluster"  # Manually specify the AKS cluster name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "mydns"  # Manually specify the DNS prefix

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

    # Manually specify SSH key data or remove if not needed
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
