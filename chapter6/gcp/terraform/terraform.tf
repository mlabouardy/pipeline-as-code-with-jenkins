provider "google" {
  credentials = file(var.credentials_path)
  project     = var.project
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.credentials_path)
  project     = var.project
  region      = var.region
}