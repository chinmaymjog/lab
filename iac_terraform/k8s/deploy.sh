#!/bin/bash
source ./addons/.creds
source ./global_variables
az login --service-principal -t $tenant_id -u $client_id -p $client_secret
#Saz group create --name $resource_group --location $location
#az group create --name $terraform_stats --location $location
#az storage account create --resource-group $terraform_stats --name $storage_account
#az storage container create --account-name $storage_account --name $container_name


#cp ./addons/.creds ./terraform/backend_var.tfvars
cd ./packer

cat <<EOF > ./vars.json
{
  "subscription_id": "$subscription_id",
  "tenant_id": "$tenant_id",
  "client_id": "$client_id",
  "client_secret": "$client_secret",
  "location": "$location",
  "resource_group": "$resource_group",
  "source_image": "$source_image"
}
EOF

packer validate -var-file=./vars.json ./azure-img.json


cd ../terraform
#cd ./terraform
cp ../global_variables ./cluster_var.tfvars
echo "a_key=`az storage account keys list -n k8sclusterterraformstats --query [0].value`" >> .storage_access
source .storage_access

ARM_ACCESS_KEY="$a_key"
ARM_CLIENT_ID=$client_id
ARM_CLIENT_SECRET=$client_secret
ARM_SUBSCRIPTION_ID=$subscription_id
ARM_TENANT_ID=$tenant_id

export ARM_ACCESS_KEY
export ARM_CLIENT_ID
export ARM_CLIENT_SECRET
export ARM_SUBSCRIPTION_ID
export ARM_TENANT_ID

cat <<EOF >./backend_conf.tfvars

storage_account_name="$storage_account"
container_name="tfstate"
key="${resource_group}.tfstate"

EOF

terraform init -var-file="./cluster_var.tfvars" -backend-config="./backend_conf.tfvars"
#terraform validate
terraform plan -var-file="./cluster_var.tfvars"  # -auto-approve