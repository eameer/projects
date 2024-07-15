resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  private_cluster_enabled = false
  azure_policy_enabled = false
  http_application_routing_enabled = true
  local_account_disabled = false
  open_service_mesh_enabled = false
  
  dynamic "default_node_pool" {
    for_each = var.enable_auto_scaling ? [1]:[]
    content {
      name            = "agentpoola"
      node_count      = var.agent_count
      vm_size         = var.kubernetes_vm_size
      os_disk_size_gb = var.os_disk_size_gb
      type            = "VirtualMachineScaleSets"
      vnet_subnet_id  = var.vnet_subnet_a_id
      enable_auto_scaling = var.enable_auto_scaling
      max_count = var.scale_max_count
      min_count = var.scale_min_count

    }
  }
  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin = "azure"
    outbound_type = var.outbound_type
    network_policy = "azure"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  lifecycle {
    ignore_changes = [
      network_profile[0].load_balancer_profile[0].idle_timeout_in_minutes
    ]
  }
}