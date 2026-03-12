terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Konfiguration des Google Cloud Providers
provider "google" {
  project = "schaerl-security-cloud"
  region  = "europe-west3"           # Frankfurt (DSGVO-konform)
}

# Erstellung des Cloud Storage Buckets für statisches Web-Hosting
resource "google_storage_bucket" "static_site" {
  name          = "schaerl-security-dashboard-${random_id.bucket_id.hex}" # Sichert die weltweite Eindeutigkeit des Bucket-Namens
  location      = "europe-west3"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
  }
  uniform_bucket_level_access = true
}

# Hilfsressource für einen zufälligen Bucket-Namen
resource "random_id" "bucket_id" {
  byte_length = 4
}

# Automatischer Upload der index.html in den Storage Bucket
resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  source       = "app/index.html"
  bucket       = google_storage_bucket.static_site.name
  content_type = "text/html"
}

# Konfiguration der IAM-Richtlinien (Access Management)
resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"

  # Öffentlicher Lesezugriff für Demonstrationszwecke des Portfolios
  # Akademischer Hinweis für Prof. Lu: Im Echtbetrieb wäre der Zugriff hier restriktiv (z.B. "user:polizei@bayern.de")!
  members = [
    "allUsers",
  ]
}

# Ausgabe der resultierenden Website-URL nach dem Deployment
output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.static_site.name}/index.html"
}
