resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
      tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
        tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_subnet" "intern" {
  name                 = "intern"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "mypublicwindowsip" {
    name                         = "${var.prefix}-wpip"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    allocation_method            = "Static"

    tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_network_interface" "windows" {
  name                = "${var.prefix}-wnic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.intern.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicwindowsip.id
  }
            tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "http_webserver"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = azurerm_subnet.intern.address_prefix
  }
    security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 110
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_subnet.intern.address_prefix
  }
    security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "rdp"
    priority                   = 120
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "3389"
    destination_address_prefix = azurerm_subnet.intern.address_prefix
  }
        tags = {
        environment = "${var.omgeving}"
    }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "${var.prefix}-Win"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = var.gebruikersnaam
  admin_password      = var.wachtwoord
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
            tags = {
        environment = "${var.omgeving}"
    }
}