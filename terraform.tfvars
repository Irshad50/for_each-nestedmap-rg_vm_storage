rg_aqsa1 = {

  resource_rg1_aqsa = {

    name     = "rg1_dev"
    location = "eastus"
  }
  resource_rg2_aqsa = {

    name     = "rg1_prod"
    location = "centralindia"
  }
}

storage_aqsa1 = {

  storage1_aqsa = {

    name                     = "aqsadev001storage"
    location                 = "eastus"
    resource_group_key        = "resource_rg1_aqsa"
    account_tier             = "Standard"
    account_replication_type = "GRS"
  }

  storage2_aqsas = {

    name                     = "aqsaprod001storage"
    location                 = "centralindia"
    resource_group_key        = "resource_rg2_aqsa"
    account_tier             = "Standard"
    account_replication_type = "GRS"
  }
}

vnets = {

  vnet1 = {

    name               = "dev_vnet"
    location           = "centralindia"
    resource_group_key = "resource_rg2_aqsa"
    address_space      = ["10.0.0.0/16"]
  }
}

subnets = {

  subnet1 = {
    name     = "web-subnet"
    vnet_key = "vnet1"
    prefixes = ["10.0.1.0/24"]
  }
}

nsgs = {

  nsg1 = {
    name               = "web-nsg"
    resource_group_key = "resource_rg2_aqsa"
    location           = "centralindia"
  }
}

public_ips = {

  pip1 = {
    name               = "web-pip"
    resource_group_key = "resource_rg2_aqsa"
    location           = "centralindia"
  }
}

nics = {

  nic1 = {
    name       = "web-nic"
    rg_key     = "resource_rg2_aqsa"
    location   = "centralindia"
    subnet_key = "subnet1"
    pip_key    = "pip1"
  }
}

vms = {

  vm1 = {
    name     = "webvm01"
    rg_key   = "resource_rg2_aqsa"
    location = "centralindia"
    nic_key  = "nic1"
    size     = "Standard_D2s_V3"
  }
}