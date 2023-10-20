variable "company_name" {
  type        = string
  description = "The company name."
}

variable "environment" {
  type        = string
  description = "The system's environment."
}

variable "ip_address" {
  type        = string
  description = "The Global HTTP Load Balancer IP address."
}

variable "untrust_network_name" {
  type        = string
  description = "The untrust VPC network name."
}

variable "app_migs" {
  type        = list(string)
  description = "App Managed Instance Groups."
}