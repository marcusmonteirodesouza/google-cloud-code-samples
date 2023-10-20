variable "company_name" {
  default     = "gcloudsamples"
  description = "The company name."
}

variable "environment" {
  default     = "dev"
  description = "The system's environment."
}

variable "app_name" {
  default     = "hello-world"
  description = "The application's name."
}

variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "region" {
  default     = "northamerica-northeast1"
  description = "The default Google Cloud region for the created resources."
}

variable "untrust_subnets" {
  default = {
    northamerica-northeast1 = {
      subnet_name   = "gcloudsamples-dev-untrust-na-ne1-subnet"
      subnet_region = "northamerica-northeast1"
      subnet_ip     = "10.162.0.0/20"
    }
    northamerica-northeast2 = {
      subnet_name   = "gcloudsamples-dev-untrust-na-ne2-subnet"
      subnet_region = "northamerica-northeast2"
      subnet_ip     = "10.188.0.0/20"
    }
  }
  description = "A map of the untrusted VPC network subnets. Each key corresponds to a Google Cloud region."
}

variable "app_mig_configs" {
  default = {
    northamerica-northeast1 = {
      machine_type = "e2-standard-2"
    }
    northamerica-northeast2 = {
      machine_type = "e2-standard-2"
    }
  }
  description = "The app Managed Instance groups configuration. Each key corresponds to a Google Cloud region."
}