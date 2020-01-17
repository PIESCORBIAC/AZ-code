# Configure the microsoft Azure Provider
provider "azurerm" {
	subscription_id = "319af888-db47-46b4-8bc3-eaced3624955"
	client_id	= "29c64791-8cc5-403e-8c4e-ffd48afb9547"
	client_secret	= "VwedagtaJExjWTWXY34bII2ZZScL+heI3bCaZ/osph8="
	tenant_id	= "0d8f0eb9-d049-44ce-b0a1-22a4bbc4b79d"
}

#creation de ressource group
resource "azurerm_resource_group" "RGterraform" {
	name = "RG-Terraform"
	location = "westeurope"
}