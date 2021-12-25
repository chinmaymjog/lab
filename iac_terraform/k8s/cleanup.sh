#!/bin/bash
## This script will deploy AKS cluster.
cd ./terraform
terraform destroy -var-file="./cluster_var.tfvars" -var-file="./backend_var.tfvars" -auto-approve