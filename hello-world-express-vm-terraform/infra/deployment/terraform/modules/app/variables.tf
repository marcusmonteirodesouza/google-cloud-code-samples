variable "app_name" {
  type        = string
  description = "The application's name."
}

variable "region" {
  type        = string
  description = "The default Google Cloud region for the created resources."
}

variable "app_sa_email" {
  type        = string
  description = "The app Service Account email."
}

variable "untrust_network_name" {
  type        = string
  description = "The untrust VPC network name."
}

variable "untrust_subnets" {
  type = map(object({
    subnet_name   = string
    subnet_region = string
    subnet_ip     = string
  }))
  description = "A map of the untrusted VPC network subnets. Each key corresponds to a Google Cloud region."
}

variable "app_mig_configs" {
  type = map(object({
    machine_type = string
  }))
  description = "The app Managed Instance groups configuration. Each key corresponds to a Google Cloud region."
}