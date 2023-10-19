variable "company_name" {
  default     = "gcloudsamples"
  description = "The company name."
}

variable "environment" {
  default     = "dev"
  description = "The system's environment."
}

variable "untrust_subnets" {
  type = map(object({
    subnet_name   = string
    subnet_region = string
    subnet_ip     = string
  }))
  description = "A map of the untrusted VPC network subnets. Each key corresponds to a Google Cloud region."
}