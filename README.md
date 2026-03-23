# IU Cloud Programming Projekt - Phase 2

Dieses Repository enthält die modularisierte Infrastruktur-als-Code (IaC) Konfiguration für das **"Schaerl Security Dashboard"**.

Im Rahmen einer agilen Cloud-Migration (aufgrund administrativer Policy-Blockaden bei Azure) wurde die Architektur auf die Google Cloud Platform verlegt und nach offiziellen Cloud Security Best Practices refaktoriert.

## Technologie-Stack

* **Cloud Provider:** Google Cloud Platform (GCP)

* **Region:** `europe-west3` (Frankfurt) – Strikte DSGVO-Konformität

* **IaC Tool:** HashiCorp Terraform

* **Hosting:** Google Cloud Storage (Serverless statisches Web-Hosting)

## Architektur & Best Practices

Das Projekt wurde von einem monolithischen Proof of Concept in eine modulare Best-Practice-Struktur überführt:

* **Audit Logging:** Ein dedizierter Log-Bucket erfasst alle Zugriffe.

* **Data Lifecycle:** Versionierung ist aktiviert, alte Dateiversionen werden nach 30 Tagen automatisiert gelöscht.

* **Security by Design:** `uniform_bucket_level_access` verhindert versehentliche ACL-Freigaben auf Dateiebene.

## Dateistruktur

* `variables.tf`: Enthält alle parametrisierten Werte (Project ID, Region, Tags, Präfixe) für eine einfache Replizierbarkeit in andere Umgebungen (Dev/Prod).

* `main.tf`: Die Kernlogik. Erstellt den Log-Bucket, den Haupt-Bucket, konfiguriert das IAM (Identity and Access Management) und lädt die Webseite hoch.

* `outputs.tf`: Definiert die Rückgabewerte nach erfolgreichem Deployment (z.B. die finale Dashboard-URL).

* `app/index.html`: Die statische HTML-Datei des Dashboards.