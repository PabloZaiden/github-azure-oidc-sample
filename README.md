# GitHub + Azure OIDC Sample

This repository is a sample of how to create pipelines authenticating to Azure with GitHub using OIDC.

Happy secretless auth!

## How to use the sample

- Run the `create_entra_app.sh` script to create a service principal with permissions to create and read resource groups, and add a federated credential to it, associated with the target GitHub repository.

- Add the `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID` printed by the script as secrets to the GitHub repository.

- Trigger the desired pipeline.

## Notes

- The script creates a federated credential with a subject pointing to a GitHub environment in the repository. That can be changed to a specific branch, tag or pull request by modifying the `create_entra_app.sh` script.
