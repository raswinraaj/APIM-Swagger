
terraform{
backend "azurerm"{   
   storage_account_name = "__storageaccount_name__"
   container_name       = "__container_name__"
    key                  = "__terraformstatefile__"    
    access_key = "__storageaccount_accesskey__"
}
}