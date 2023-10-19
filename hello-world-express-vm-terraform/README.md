# Hello, World! - Express - Terraform - VM

A [Hello, World!](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program) [Express](https://expressjs.com/) application served from a [Virtual Machine instance](https://cloud.google.com/compute/docs/instances).

Provisioned with [terraform](https://www.terraform.io/).

## Architecture

## Deployment

1. [Install terraform](https://developer.hashicorp.com/terraform/downloads).
1. [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install).
1. [Create a Google Cloud project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project).
1. Run [`gcloud auth login`](https://cloud.google.com/sdk/gcloud/reference/auth/login).
1. Run [`gcloud auth application-default login`](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login). 
1. `cd` into the [`terraform` folder](./infra/deployment/terraform/)
1. Run `cp terraform.tfvars.template terraform.tfvars` and fill out the variables with your own values.
1. Comment out the contents of the `backend.tf` file.
1. Run `terraform init`.
1. Run `terraform apply -target=module.enable_apis`.
1. Run `terraform apply`.
1. Uncomment the contents of the `backend.tf` and set the `bucket` attribute to the value of the `tfstate_bucket` output.
1. Run `terraform init` and type `yes`.