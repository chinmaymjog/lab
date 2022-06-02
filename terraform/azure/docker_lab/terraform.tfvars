project           = "docker-lab"
location          = "Central India"
rgname            = "rg-docker-lab"
tfstate_storage   = "azterraformstatefiles"
tfstate_container = "docker-lab"
enable_docker_vm  = "true"
#docker_vm_count = 3

# Variables for single docker VM 
vmsize       = "Standard_B2s"
vmsku        = "18.04-LTS"
datadisksize = "30"
username     = "dockeruser"