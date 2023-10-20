output "ip_address" {
  value = module.global_http_load_balancer.external_ip
}

output "terraform_tfvars" {
  value = google_secret_manager_secret.terraform_tfvars.id
}

output "tfstate_bucket" {
  value = google_storage_bucket.tfstate.name
}


