environment="dev"
cluster_id="1"
location="centralus"
resource_group="k8s_dev_1_centralus_rg"
terraform_stats="terraformstate_rg"
storage_account="k8sclusterterraformstats"
container_name="tfstate"
source_image="source_image_dev_1_centralus"
token="ge5uwt.rnd7bmvkugfzorqm"

vnet="172.16.0.0/16"
pod_subnet="172.16.0.0/22"
kub_subnet="172.16.4.0/26"
bastion_subnet="172.16.4.64/28"
redis_subnet="172.16.4.80/28"

mastervm_size="Standard_D2s_v3"
mastervm_count="1"
nodevm_size="Standard_D2s_v3"
nodevm_count="1"
bastionvm_size="Standard_D2s_v3"
