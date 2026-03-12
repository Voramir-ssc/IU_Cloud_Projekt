# IU Cloud Programming Projekt - Phase 2

Dieses Repository enthält die Infrastruktur-als-Code (IaC) Konfiguration für das "Schaerl Security Dashboard".

## Technologie-Stack
- **Cloud Provider:** Google Cloud Platform (GCP)
- **IaC Tool:** Terraform
- **Hosting:** Google Cloud Storage (Statisches Web-Hosting)

## Struktur
- `main.tf`: Enthält die Terraform-Konfiguration für die Erstellung des GCP Storage Buckets, IAM-Richtlinien und den automatischen Upload der Webseite.
- `app/index.html`: Die statische HTML-Datei des Dashboards.

## Deployment
1. Google Cloud CLI installieren und authentifizieren (`gcloud auth application-default login`).
2. Terraform initialisieren mit `terraform init`.
3. Plan überprüfen mit `terraform plan`.
4. Infrastruktur anwenden mit `terraform apply`.
