data "azurerm_image" "source_image" {
    resource_group_name = "rg-custom-images"
    name = "ub-1804-docker-2"
}