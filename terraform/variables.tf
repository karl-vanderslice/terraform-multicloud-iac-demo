# Special Message to insert as User data, shown in the provisioned virtual machine web page.
variable "special_message" {
  default     = "Use Infrastructure as Code to provision and manage any cloud, infrastructure, or service."
  description = "Message to insert as userdata on each provisioned virtual machine instance."
}

# AWS specific
variable "aws_instance_type" {
  default     = "t2.micro"
  description = "Size of the AWS instance to provision for EC2.  See https://aws.amazon.com/ec2/instance-types/."
}

variable "vpc_id" {
  description = "ID of the VPC to use for provisioning compute resources.  Can be identified by using `awscli` command `aws ec2 describe-vpcs`."
}

variable "route53_domain_name" {
  description = "Name of the root domain to use for DNS rescords.  Must already exist and be writeable by the credentials Terraform is running under.  Example: `devops.mydomain.io`."
}

variable "aws_instance_host_name" {
  description = "The host name to assign the AWS EC2 instance."
  default     = "hello-world-aws"
}

variable "aws_instance_fqdn" {
  description = "The Fully Qualified Domain Name to assign the AWS EC2 instance."
  default     = "hello-world-aws"
}

# Azure
variable "resource_group_name" {
  description = "Name of the Azure resource group to provision resources in.  Must already exist and be writeable by the credentials Terraform is running under.  Example: `devopsDemo`."
}

variable "azure_instance_type" {
  description = "Size of the Azure instance to provision for Azure Compute.  See https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs."
  default     = "Standard_F2"
}

# GCP 

variable "gcp_credentials" {
  description = "Location of the Service Account credentials JSON file for Google Cloud.  See https://cloud.google.com/docs/authentication/getting-started for more information."
}

variable "gcp_project_id" {
  description = "Name of the GCP Project to work under.  Example: `devopsdemo-0000000`.  Must already exist and the Service Account credentials must have permission to provision resources in this project."
}

variable "gcp_region" {
  description = "Region to provision resources in Google Cloud.  Example: `us-east1`.  See https://cloud.google.com/compute/docs/regions-zones/ for more information."
}

variable "gcp_zone" {
  description = "Zone to provision resources in Google Cloud.  Example: `us-east1-b`."
}

variable "gcp_instance_type" {
  default     = "f1-micro"
  description = "Size of the Google Compute instance to provision.  See https://cloud.google.com/compute/docs/machine-types"
}

# Digital Ocean 

variable "do_region" {
  description = "Digital Ocean region to provision resources in.  Example: `nyc1`.  See https://www.digitalocean.com/docs/platform/availability-matrix/ for more information."
}

variable "do_instance_type" {
  default     = "s-1vcpu-1gb"
  description = "Size of the Digital Ocean droplet to provision.  See https://developers.digitalocean.com/documentation/changelog/api-v2/new-size-slugs-for-droplet-plan-changes/."
}

# Generic
variable "public_key" {
  description = "Public Key to add to provisioned instances.  Example: `cat ~/.ssh/id_rsa.pub`."
}

variable "hello_world_image_name" {
  default     = "hello-world-f247c50-develop"
  description = "Name of the machine image (Snapshot on Digital Ocean) to provision.  Must exist and already be created via Packer."
}

# Tag variables

variable "orgname" {
  description = "Organization name to add to tags.  Example: `myorg`."
}

variable "environment_name" {
  description = "Environment name to add to tags.  Example: `dev`, `test`, `uat`, `stage`, `sut`, `prod`."
}

variable "service" {
  description = "Service name to add to tags.  Example: `devops`."
}

variable "name" {
  description = "Project name to add to tags and resources.  Example: `myorg-devops-hello-world-f1e3b30-develop`.  Recommended to use `$ORGNAME-$SERVICE-$APPLICATION-$BUILD_ID` in your shell."
}

variable "application" {
  default     = "hello-world"
  description = "Name of the application to add to tags and resources."
}

variable "cost_center" {
  description = "Cost center to add to tags.  Example: `00000` or `informationTechnology`."
}

variable "data_classification" {
  default     = "public"
  description = "Type of data to add to tags.  Example: `private`, `public`, `sensitive`."
}

variable "owner" {
  description = "Contact information for the owner of this resource.  Should be an email address."
}

variable "tagging_version" {
  default     = "0.1.0"
  description = "Version of the tag model to apply to tags for reference."
}

variable "build_id" {
  description = "Build ID to add to tags.  Example: `$GIT_HASH-$GIT_BRANCH`."
}

# tags are compatible with Azure/AWS.
# tags_underscore are used for Google Compute.
# Digital Ocean provisions tags as individaul resources.
locals {
  tags = {
    "${var.orgname}:service"            = "${var.service}"
    "${var.orgname}:environmentName"    = "${var.environment_name}"
    "Name"                              = "${var.orgname}:${var.service}:${var.environment_name}:${var.application}:${var.build_id}"
    "${var.orgname}:application"        = "${var.application}"
    "${var.orgname}:costCenter"         = "${var.cost_center}"
    "${var.orgname}:dataClassification" = "${var.data_classification}"
    "${var.orgname}:owner"              = "${var.owner}"
    "${var.orgname}:taggingVersion"     = "${var.tagging_version}"
    "${var.orgname}:buildId"            = "${var.build_id}"
  }

  tags_underscore = {
    "${lower(var.orgname)}_service"            = "${lower(var.service)}"
    "${lower(var.orgname)}_environmentname"    = "${lower(var.environment_name)}"
    "name"                                     = "${lower(var.orgname)}-${lower(var.service)}-${lower(var.environment_name)}-${lower(var.application)}-${lower(var.build_id)}"
    "${lower(var.orgname)}_application"        = "${lower(var.application)}"
    "${lower(var.orgname)}_costcenter"         = "${lower(var.cost_center)}"
    "${lower(var.orgname)}_dataclassification" = "${lower(var.data_classification)}"
    "${lower(var.orgname)}_taggingversion"     = "0-1-0"
    "${lower(var.orgname)}_buildid"            = "${lower(var.build_id)}"
  }

}

