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

# Check if the resource group already exists.
# If it does, exit successfully.
exists=$(az group exists --name $resourceGroupName)
if [ $exists == true ]; then
    echo "Resource group '$resourceGroupName' already exists."
    exit 0
fi

# Create the resource group
az group create --name $resourceGroupName --location $location
