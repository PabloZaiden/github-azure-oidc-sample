#!/usr/bin/env bash

set -e

# Read the resource group name from the first argument
resourceGroupName=$1

# Check if the resource group name is provided.
if [ -z "$resourceGroupName" ]; then
    echo "Resource group name is required."
    exit 1
fi
echo "Resource group name: $resourceGroupName"

# Read the location from the second argument
location=$2

# Check if the location is provided.
if [ -z "$location" ]; then
    echo "Location is required."
    exit 1
fi

# deploy with main.tf
dirName=$(dirname "${BASH_SOURCE[0]}")
cd "$dirName"

# if terraform is not installed, install it
if [ ! -x "$(command -v terraform)" ]; then
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
fi

# get current subscription id
subscriptionId=$(az account show --query id -o tsv)

terraform init

# since the resource group might already exist in the sample, we need to try to import it
tfResourceName="azurerm_resource_group.myResourceGroup"
tfResourceId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"

terraform import -var "resource_group_name=$resourceGroupName" -var "location=$location" -var "subscription_id=$subscriptionId" $tfResourceName $tfResourceId 2>/dev/null || true

terraform apply -auto-approve -var "resource_group_name=$resourceGroupName" -var "location=$location" -var="subscription_id=$subscriptionId"
