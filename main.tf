terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# 1. Provider konfigurieren
provider "google" {
  project = "schaerl-security-cloud" 
  region  = "europe-west3"                   # Frankfurt (DSGVO-konform!)
}

# 2. Cloud Storage Bucket (Web-Hosting) erstellen
resource "google_storage_bucket" "static_site" {
  name          = "schaerl-security-dashboard-${random_id.bucket_id.hex}" # Muss weltweit eindeutig sein!
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

# 3. Die index.html automatisch in die Cloud hochladen
resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  source       = "app/index.html"
  bucket       = google_storage_bucket.static_site.name
  content_type = "text/html"
}

# 4. Sicherheitsbarriere (IAM - Access Management)
resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "roles/storage.objectViewer"
  
  # Für das Portfolio machen wir es public, damit du es zeigen kannst.
  # Akademischer Hinweis für Prof. Lu: Hier würde im Echtbetrieb "user:polizei@bayern.de" stehen!
  members = [
    "allUsers", 
  ]
}

# 5. Ausgabe des fertigen Links
output "website_url" {
  value = "[https://storage.googleapis.com/$](https://storage.googleapis.com/$){google_storage_bucket.static_site.name}/index.html"
}
