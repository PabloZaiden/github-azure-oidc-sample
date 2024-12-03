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

# deploy with bicep main.bicep and main.bicepparam
RESOURCE_GROUP_NAME=$resourceGroupName LOCATION=$location az deployment sub create --location $location --template-file ./bicep/main.bicep --parameters ./bicep/main.bicepparam