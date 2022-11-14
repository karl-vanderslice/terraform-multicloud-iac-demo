# Hello World App

A simple multi-cloud Hello World using [Terraform](https://github.com/hashicorp/terraform), [Packer](https://github.com/hashicorp/packer), [Ansible](https://github.com/ansible/ansible), and [Docker](https://github.com/docker).

## Requirements

### Tooling

-   Terraform 0.12.24
-   Packer 1.5.4
-   Ansible 2.9.6
-   Docker 19.03.8

Docker must be usable by the user running the Packer command and uses the environment variable `DOCKER_HOST` (default `unix:///var/run/docker.sock`).

### Cloud Providers

This project leverages free or inexpensive tier resources on the following providers:

-   [Amazon Web Services](https://aws.amazon.com/)
-   [Azure](https://azure.microsoft.com/en-us/)
-   [Google Compute](https://cloud.google.com/)
-   [Digital Ocean](https://www.digitalocean.com/)

Note that AWS and Azure assume the current working Region is set via `AWS_REGION` for AWS, and the provisioned Resource Group for Azure.

# Running the script

-   Examine the Packer scripts and set environment variables, pass in `variables.json` to Packer, or change the user variables to suit your needs.
-   Set any required `vars` under `ansible/site.yml` to match your working environment, or pass in variables via `--extra_vars` option to `ansible-playbook`.
-   Set the `hello_world_image_name` variable in `variables.tf` to match the created image name output by Packer.

## Setting tfvars

This project assumes you are setting variables via an untracked `.tfvars` file or preferably via exporting in your shell:

```
export TF_VAR_build_id="$(git rev-parse --short HEAD)-$(git rev-parse --abbrev-ref HEAD)"
export TF_VAR_cost_center="${COST_CENTER}"
export TF_VAR_data_classification="${DATA_CLASSIFICATION}"
export TF_VAR_environment_name="${ENVIRONMENT_NAME}"
export TF_VAR_name="${ORGNAME}-${SERVICE}-${ENVIRONMENT_NAME}-hello-world-$(git rev-parse --short HEAD)-$(git rev-parse --abbrev-ref HEAD)"
export TF_VAR_orgname="${ORGNAME}"
export TF_VAR_owner="${OWNER}"
export TF_VAR_public_key="${SSH_PUBLIC_KEY}"
export TF_VAR_service="${SERVICE}"
export TF_VAR_vpc_id=<VPC ID>
export TF_VAR_resource_group_name=<your azure resource group name>
export TF_VAR_gcp_credentials=<path to your gcp service account json file>
export TF_VAR_gcp_project_id=<name of your GCP project>
export TF_VAR_gcp_region=<gcp region to provision infrastructure in>
export TF_VAR_gcp_zone=<gcp zone to provision infrastructure in>
export TF_VAR_do_region=<your digital ocean region>
export TF_VAR_route53_domain_name=<your domain name in route 53>
```

## Executing Terraform

From the `terraform/` directory:

Initialize:

```
$ terraform init
```

Plan:

```
$ terraform plan
```

Apply and create resources:

```
$ terraform apply
```

Teardown:

```
$ terraform destroy
```

# terraform-docs

## Requirements

| Name         | Version   |
| ------------ | --------- |
| terraform    | = 0.12.24 |
| aws          | = 2.54.0  |
| azurerm      | = 2.3.0   |
| digitalocean | = 1.15.1  |
| google       | = 3.14.0  |
| null         | = 2.1.2   |
| template     | =2.1.2    |

## Providers

| Name         | Version  |
| ------------ | -------- |
| aws          | = 2.54.0 |
| azurerm      | = 2.3.0  |
| digitalocean | = 1.15.1 |
| google       | = 3.14.0 |
| template     | =2.1.2   |

## Inputs

| Name                   | Description                                                                                                                                                                               | Type     | Default                                                                                       | Required |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------- | :------: |
| application            | Name of the application to add to tags and resources.                                                                                                                                     | `string` | `"hello-world"`                                                                               |    no    |
| aws_instance_fqdn      | The Fully Qualified Domain Name to assign the AWS EC2 instance.                                                                                                                           | `string` | `"hello-world-aws"`                                                                           |    no    |
| aws_instance_host_name | The host name to assign the AWS EC2 instance.                                                                                                                                             | `string` | `"hello-world-aws"`                                                                           |    no    |
| aws_instance_type      | Size of the AWS instance to provision for EC2. See https://aws.amazon.com/ec2/instance-types/.                                                                                            | `string` | `"t2.micro"`                                                                                  |    no    |
| azure_instance_type    | Size of the Azure instance to provision for Azure Compute. See https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs.                                          | `string` | `"Standard_F2"`                                                                               |    no    |
| build_id               | Build ID to add to tags. Example: `$GIT_HASH-$GIT_BRANCH`.                                                                                                                                | `any`    | n/a                                                                                           |   yes    |
| cost_center            | Cost center to add to tags. Example: `00000` or `informationTechnology`.                                                                                                                  | `any`    | n/a                                                                                           |   yes    |
| data_classification    | Type of data to add to tags. Example: `private`, `public`, `sensitive`.                                                                                                                   | `string` | `"public"`                                                                                    |    no    |
| do_instance_type       | Size of the Digital Ocean droplet to provision. See https://developers.digitalocean.com/documentation/changelog/api-v2/new-size-slugs-for-droplet-plan-changes/.                          | `string` | `"s-1vcpu-1gb"`                                                                               |    no    |
| do_region              | Digital Ocean region to provision resources in. Example: `nyc1`. See https://www.digitalocean.com/docs/platform/availability-matrix/ for more information.                                | `any`    | n/a                                                                                           |   yes    |
| environment_name       | Environment name to add to tags. Example: `dev`, `test`, `uat`, `stage`, `sut`, `prod`.                                                                                                   | `any`    | n/a                                                                                           |   yes    |
| gcp_credentials        | Location of the Service Account credentials JSON file for Google Cloud. See https://cloud.google.com/docs/authentication/getting-started for more information.                            | `any`    | n/a                                                                                           |   yes    |
| gcp_instance_type      | Size of the Google Compute instance to provision. See https://cloud.google.com/compute/docs/machine-types                                                                                 | `string` | `"f1-micro"`                                                                                  |    no    |
| gcp_project_id         | Name of the GCP Project to work under. Example: `devopsdemo-0000000`. Must already exist and the Service Account credentials must have permission to provision resources in this project. | `any`    | n/a                                                                                           |   yes    |
| gcp_region             | Region to provision resources in Google Cloud. Example: `us-east1`. See https://cloud.google.com/compute/docs/regions-zones/ for more information.                                        | `any`    | n/a                                                                                           |   yes    |
| gcp_zone               | Zone to provision resources in Google Cloud. Example: `us-east1-b`.                                                                                                                       | `any`    | n/a                                                                                           |   yes    |
| hello_world_image_name | Name of the machine image (Snapshot on Digital Ocean) to provision. Must exist and already be created via Packer.                                                                         | `string` | `"hello-world-f247c50-develop"`                                                               |    no    |
| name                   | Project name to add to tags and resources. Example: `myorg-devops-hello-world-f1e3b30-develop`. Recommended to use `$ORGNAME-$SERVICE-$APPLICATION-$BUILD_ID` in your shell.              | `any`    | n/a                                                                                           |   yes    |
| orgname                | Organization name to add to tags. Example: `myorg`.                                                                                                                                       | `any`    | n/a                                                                                           |   yes    |
| owner                  | Contact information for the owner of this resource. Should be an email address.                                                                                                           | `any`    | n/a                                                                                           |   yes    |
| public_key             | Public Key to add to provisioned instances. Example: `cat ~/.ssh/id_rsa.pub`.                                                                                                             | `any`    | n/a                                                                                           |   yes    |
| resource_group_name    | Name of the Azure resource group to provision resources in. Must already exist and be writeable by the credentials Terraform is running under. Example: `devopsDemo`.                     | `any`    | n/a                                                                                           |   yes    |
| route53_domain_name    | Name of the root domain to use for DNS rescords. Must already exist and be writeable by the credentials Terraform is running under. Example: `devops.mydomain.io`.                        | `any`    | n/a                                                                                           |   yes    |
| service                | Service name to add to tags. Example: `devops`.                                                                                                                                           | `any`    | n/a                                                                                           |   yes    |
| special_message        | Message to insert as userdata on each provisioned virtual machine instance.                                                                                                               | `string` | `"Use Infrastructure as Code to provision and manage any cloud, infrastructure, or service."` |    no    |
| tagging_version        | Version of the tag model to apply to tags for reference.                                                                                                                                  | `string` | `"0.1.0"`                                                                                     |    no    |
| vpc_id                 | ID of the VPC to use for provisioning compute resources. Can be identified by using `awscli` command `aws ec2 describe-vpcs`.                                                             | `any`    | n/a                                                                                           |   yes    |

## Outputs

| Name          | Description                                |
| ------------- | ------------------------------------------ |
| aws_address   | Web address for the AWS instance           |
| azure_address | Web address for the Azure instance         |
| do_address    | Web address for the Digital Ocean instance |
| gcp_address   | Web address for the GCP instance           |
