resource "azurerm_resource_group" "rg_aqsa" {
  for_each = var.rg_aqsa1

  name     = each.value.name
  location = each.value.location
}

resource "azurerm_storage_account" "storage_aqsa" {
  for_each                 = var.storage_aqsa1
  name                     = each.value.name
  location                 = each.value.location
  resource_group_name      = azurerm_resource_group.rg_aqsa[each.value.resource_group_key].name
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

resource "azurerm_virtual_network" "aqsa_vnets" {

  for_each = var.vnets

  name = each.value.name

  resource_group_name = azurerm_resource_group.rg_aqsa[each.value.resource_group_key].name

  location = each.value.location

  address_space = each.value.address_space
}

resource "azurerm_subnet" "subnet" {

  for_each = var.subnets

  name = each.value.name

  virtual_network_name = azurerm_virtual_network.aqsa_vnets[each.value.vnet_key].name

  resource_group_name = azurerm_virtual_network.aqsa_vnets[each.value.vnet_key].resource_group_name

  address_prefixes = each.value.prefixes
}

resource "azurerm_network_security_group" "nsg" {

  for_each = var.nsgs

  name = each.value.name

  resource_group_name = azurerm_resource_group.rg_aqsa[each.value.resource_group_key].name

  location = each.value.location
}

resource "azurerm_public_ip" "pip" {

  for_each = var.public_ips

  name = each.value.name

  resource_group_name = azurerm_resource_group.rg_aqsa[each.value.resource_group_key].name

  location = each.value.location

  allocation_method = "Static"
}

resource "azurerm_network_interface" "nic" {

  for_each = var.nics

  name = each.value.name

  resource_group_name = azurerm_resource_group.rg_aqsa[each.value.rg_key].name

  location = each.value.location

  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.subnet[each.value.subnet_key].id

    public_ip_address_id = azurerm_public_ip.pip[each.value.pip_key].id

    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {

  for_each = var.vms

  name = each.value.name

  resource_group_name = azurerm_resource_group.rg_aqsa[each.value.rg_key].name

  location = each.value.location

  size = each.value.size

  admin_username = "azureaqsa"

  network_interface_ids = [azurerm_network_interface.nic[each.value.nic_key].id]

  admin_password = "******"

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
