data "google_project" "project" {
}

module "untrust_network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.4"

  project_id   = data.google_project.project.project_id
  network_name = "${var.company_name}-${var.environment}-untrust-vpc-1"

  subnets = values(var.untrust_subnets)

  egress_rules = [
    {
      name     = "allow-egress-all"
      priority = 65535
      ranges = [
        "0.0.0.0/0"
      ]
      allow = [
        {
          protocol = "all"
        }
      ]
    },
  ]

  ingress_rules = [
    # https://cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs#setting_up_an_autohealing_policy
    {
      name     = "allow-health-check"
      priority = 65533
      ranges = [
        "130.211.0.0/22",
        "35.191.0.0/16"
      ]
      allow = [
        {
          protocol = "TCP",
          ports = [
            "80",
            "8080"
          ]
        }
      ]
    },
    # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
    {
      name     = "allow-ingress-from-iap"
      priority = 65534
      ranges = [
        "35.235.240.0/20"
      ]
      allow = [
        {
          protocol = "TCP"
          ports = [
            "22",
            "3389"
          ]
        }
      ]
    },
    {
      name     = "deny-ingress-all"
      priority = 65535
      ranges = [
        "0.0.0.0/0"
      ]
      deny = [
        {
          protocol = "all"
        }
      ]
    },
  ]
}

module "unstrust_cloud_router" {
  for_each = var.untrust_subnets
  source   = "terraform-google-modules/cloud-router/google"
  version  = "~> 6.0"
  name     = "${var.company_name}-${var.environment}-cloud-router"
  project  = data.google_project.project.project_id
  network  = module.untrust_network.network_name
  region   = each.key

  nats = [{
    name                               = "${var.company_name}-${var.environment}-unstrust-${each.key}-nat-gateway"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                    = each.value.subnet_name
        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
      }
    ]
  }]
}