
terraform{
backend "azurerm"{   
    backend "azurerm" {
    container_name = "tfstate"
    key            = "apim.terraform.tfstate"
  }
}
}