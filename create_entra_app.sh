#!/usr/bin/env bash

set -e

#verify if jq is installed
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

# Verify if GITHUB_REPOSITORY_NAME is set
if [ -z "$GITHUB_REPOSITORY_NAME" ]; then
    echo "GITHUB_REPOSITORY_NAME is not set."
    exit 1
fi

echo "Read the current subscription"
subscriptionId=$(az account show --query id -o tsv)

echo "Create an Entra App with service principal and make it subscription contributor"
spValues=$(az ad sp create-for-rbac --role contributor --scopes /subscriptions/$subscriptionId)

appId=$(echo $spValues | jq -r .appId)
tenantId=$(echo $spValues | jq -r .tenant)

echo "Values for the Github Secrets"
echo ""
echo "AZURE_CLIENT_ID=$appId"
echo "AZURE_TENANT_ID=$tenantId"
echo "AZURE_SUBSCRIPTION_ID=$subscriptionId"

echo "Configuring federated identity for Github Actions, based on repo name and main branch"
echo "Replace the subject with the desired subject for the federated credential (environment, branch, tags, pull-request: https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azcli#github-actions-example)"
parameters=$(cat <<EOF
{
    "name": "sample-app-credential",
    "issuer": "https://token.actions.githubusercontent.com/",
    "subject": "repo:$GITHUB_REPOSITORY_NAME:ref:refs/heads/main",
    "description": "Sample app credential for Github Actions",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}
EOF
)

az ad app federated-credential create --id $appId --parameters "$parameters"