data "google_project" "project" {
}

# module "global_http_load_balancer" {
#   source  = "GoogleCloudPlatform/lb-http/google"
#   version = "~> 9.0"

#   project = data.google_project.project.project_id
#   name    = "${var.company_name}-${var.environment}-lb"
#   backends = {
#   }
# }