source "azure-arm" "docker-image" {
os_type = "Linux"
image_publisher = "Canonical"
image_offer = "UbuntuServer"
image_sku = "18.04-LTS"
managed_image_name = "ub-1804-docker-2"
managed_image_resource_group_name = "rg-custom-images"
location = "Central India"
subscription_id = "46383509-ef7e-4e4b-8f95-ff6fc82f651c"
vm_size = "Standard_B1s"
}

build {
    name = "test"
    sources = [
    "source.azure-arm.docker-image",
    ]

    provisioner "shell" {
    script = "./install_docker.sh"
}
}