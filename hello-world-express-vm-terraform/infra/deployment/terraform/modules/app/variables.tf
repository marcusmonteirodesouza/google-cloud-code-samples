variable "region" {
  type        = string
  description = "The default Google Cloud region for the created resources."
}

variable "app_sa_email" {
  type        = string
  description = "The app Service Account email."
}