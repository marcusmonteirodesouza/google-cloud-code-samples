locals {
  app_sa_roles = [
  ]
}

resource "google_service_account" "app" {
  account_id   = "app-sa"
  display_name = "app Service Account"
}

resource "google_project_iam_member" "app_sa" {
  for_each = toset(local.app_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.app.email}"
}