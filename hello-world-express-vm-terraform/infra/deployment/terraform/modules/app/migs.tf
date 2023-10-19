locals {
  image_port = 8080
}

data "google_compute_zones" "available" {
}

module "app_gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image = docker_registry_image.app.name
    env = [
      {
        name  = "GCLOUD_PROJECT_ID"
        value = data.google_project.project.project_id
      },
      {
        name  = "GCLOUD_SERVICE_ID"
        value = "hello-world-express-vm-terraformd"
      },
      {
        name  = "LOG_LEVEL"
        value = "info"
      },
      {
        name  = "NODE_ENV"
        value = "production"
      },
      {
        name  = "PORT"
        value = local.image_port
      }
    ],
  }
}

module "app_instance_templates" {
  for_each     = var.app_mig_configs
  source       = "terraform-google-modules/vm/google//modules/instance_template"
  version      = "~> 7.3"
  name_prefix  = var.app_name
  region       = each.key
  machine_type = each.value.machine_type
  service_account = {
    email = var.app_sa_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.app_gce_container.source_image))[0]
  network              = var.untrust_network_name
  subnetwork           = var.untrust_subnets[each.key].subnet_name
  metadata = {
    "gce-container-declaration" = module.app_gce_container.metadata_value
  }
  labels = {
    "container-vm" = module.app_gce_container.vm_container_label
  }
}

module "app_migs" {
  for_each          = var.app_mig_configs
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.3"
  instance_template = module.app_instance_templates[each.key].self_link
  region            = each.key
  hostname          = var.app_name

  autoscaling_enabled = true

  named_ports = [
    {
      name = "http",
      port = local.image_port
    }
  ]

  health_check = {
    type                = "http"
    port                = local.image_port
    check_interval_sec  = 5
    healthy_threshold   = 1
    host                = "localhost"
    initial_delay_sec   = 300
    proxy_header        = "NONE"
    request             = ""
    request_path        = "/"
    response            = ""
    timeout_sec         = 5
    unhealthy_threshold = 3
  }
}