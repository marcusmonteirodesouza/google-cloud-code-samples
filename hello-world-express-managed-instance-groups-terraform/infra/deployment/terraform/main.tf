provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

provider "docker" {
  registry_auth {
    address  = "${var.region}-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

data "google_client_config" "default" {
}

module "enable_apis" {
  source = "./modules/enable_apis"
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/network"

  untrust_subnets = var.untrust_subnets
}

module "app" {
  source = "./modules/app"

  app_name             = var.app_name
  region               = var.region
  app_sa_email         = module.iam.app_sa_email
  untrust_network_name = module.network.untrust_network_name
  untrust_subnets      = module.network.untrust_subnets
  app_mig_configs      = var.app_mig_configs
}

resource "google_compute_global_address" "global_http_load_balancer" {
  name = "${var.company_name}-${var.environment}-global-http-load-balancer-ip"
}

module "global_http_load_balancer" {
  source = "./modules/global_http_load_balancer"

  company_name         = var.company_name
  environment          = var.environment
  external_ip          = join("", google_compute_global_address.global_http_load_balancer.*.address)
  untrust_network_name = module.network.untrust_network_name
  app_migs             = values(module.app.app_migs).*.instance_group
}