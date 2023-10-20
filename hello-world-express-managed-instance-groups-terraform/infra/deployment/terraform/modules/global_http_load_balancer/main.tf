data "google_project" "project" {
}

module "global_http_load_balancer" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 9.0"

  project = data.google_project.project.project_id
  name    = "${var.company_name}-${var.environment}-lb"

  firewall_networks = [
    var.untrust_network_name
  ]

  backends = {
    default = {
      port       = 8080
      protocol   = "HTTP"
      port_name  = "http"
      enable_cdn = false

      health_check = {
        request_path = "/"
        port         = 8080
      }

      log_config = {
        enable        = true
        sample_config = 1.0
      }

      groups = [for group in var.app_migs : { group = group }]

      iap_config = {
        enable = false
      }
    }
  }
}