resource "azurerm_linux_virtual_machine" "hello-world" {
  name                = "hello-world-azure"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  size                = var.azure_instance_type
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.main.id,
    azurerm_network_interface.internal.id,
  ]

  custom_data = base64encode(data.template_file.user_data_azure.rendered)

  tags = local.tags

  admin_ssh_key {
    username   = "ubuntu"
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.hello-world.id
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_image" "hello-world" {
  name_regex          = var.hello_world_image_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = local.tags

}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-nic1"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = local.tags

}

resource "azurerm_network_interface" "internal" {
  name                = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-nic2"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags

}

resource "azurerm_public_ip" "main" {
  name                = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Dynamic"

  tags = local.tags

}

resource "azurerm_network_security_group" "main" {
  name                = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-ssh"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  security_rule {
    name                       = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  security_rule {
    name                       = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-http"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  security_rule {
    name                       = "${var.orgname}-${var.service}-${var.environment_name}-${var.application}-${var.build_id}-https"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  tags = local.tags

}

data "template_file" "user_data_azure" {
  template = "${file("${path.module}/templates/azure/user-data.tpl")}"

  vars = {
    special_message = var.special_message
  }
}