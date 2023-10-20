locals {
  app_directory  = "${path.module}/../../../../../app"
  app_repository = "${var.region}-docker.pkg.dev/${data.google_project.project.project_id}/${google_artifact_registry_repository.app.name}"
  app_image      = "${local.app_repository}/app"
}

resource "google_artifact_registry_repository" "app" {
  location      = var.region
  repository_id = "app"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "app_sa" {
  location   = google_artifact_registry_repository.app.location
  repository = google_artifact_registry_repository.app.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.app_sa_email}"
}

resource "docker_image" "app" {
  name = local.app_image
  build {
    context = local.app_directory
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(local.app_directory, "**") : filesha1("${local.app_directory}/${f}")]))
  }
}

resource "docker_registry_image" "app" {
  name = docker_image.app.name
}
