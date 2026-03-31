terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# Best Practice: Separater Audit-Log-Bucket zur forensischen Protokollierung
resource "google_storage_bucket" "log_bucket" {
  name                        = "${var.bucket_name_prefix}-logs-${random_id.bucket_id.hex}"
  location                    = var.region
  force_destroy               = true
  labels                      = var.tags
  uniform_bucket_level_access = true
}

# Haupt-Bucket für statisches Web-Hosting inkl. Lifecycle & Versionierung
resource "google_storage_bucket" "static_site" {
  name          = "${var.bucket_name_prefix}-${random_id.bucket_id.hex}"
  location      = var.region
  force_destroy = true
  labels        = var.tags

  uniform_bucket_level_access = true

  website {
    main_page_suffix = var.index_document
  }

  versioning {
    enabled = true
  }

  logging {
    log_bucket = google_storage_bucket.log_bucket.name
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# Upload der statischen Dashboard-Datei
resource "google_storage_bucket_object" "index" {
  name         = var.index_document
  source       = "app/${var.index_document}"
  bucket       = google_storage_bucket.static_site.name
  content_type = "text/html"
}

# IAM-Zuweisung: Temporärer Lesezugriff zur Demonstration der Erreichbarkeit
resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}


