# Schaerl Security Solutions - Infrastruktur (PoC)

Dieses Repository enthält die modularisierte Infrastruktur-als-Code (IaC) Konfiguration für das initiale **"Schaerl Security Dashboard"** (Modul: Cloud Programming). 

Das Projekt dient als Proof of Concept (PoC) für eine hochverfügbare, skalierbare und DSGVO-konforme Cloud-Umgebung, die spezifisch auf die restriktiven Sicherheitsanforderungen der IT-Forensik zugeschnitten ist. 

Aufgrund administrativer Policy-Blockaden bei anderen Anbietern wurde die Architektur iterativ auf die **Google Cloud Platform (GCP)** migriert und strikt nach Cloud Security Best Practices entwickelt.

## 🛠️ Technologie-Stack

* **Cloud Provider:** Google Cloud Platform (GCP)
* **Region:** `europe-west3` (Frankfurt) – Zwingend für DSGVO-Konformität / Data Sovereignty
* **IaC Tool:** HashiCorp Terraform
* **Hosting:** Google Cloud Storage (Serverless statisches Web-Hosting inkl. gemanagtem HTTPS via storage.googleapis.com)

## 🔐 Architektur & Best Practices

Das Deployment wurde als modulares "Security by Design" Fundament konzipiert:

* **Audit Logging:** Ein physisch dedizierter Audit-Log-Bucket zur manipulationssicheren, forensischen Protokollierung aller Zugriffe, strikt isoliert von produktiven Daten.
* **Data Lifecycle (FinOps) & Sicherung:** Aktivierte Objektversionierung schützt vor Datenverlust oder Ransomware. Veraltete Speicherobjekte werden zwecks Kostenreduktion nach 30 Tagen durch eine automatische Lifecycle-Regel gelöscht.
* **Uniform Access:** Die Aktivierung von `uniform_bucket_level_access` überschreibt dateibasierte Access Control Lists (ACL) und erzwingt eine rein zentrale Steuerung über das GCP IAM.

## 📂 Dateistruktur & Module

* `variables.tf`: Enthält das Konfigurations-Interface und parametrisierte Werte wie Region und ein strenges FinOps-Tagging-System (z.B. `owner = "it-forensik"`). Verhindert Hardcoding und fördert Skalierbarkeit.
* `main.tf`: Die Architektur-Logik. Provisioniert isolierte Buckets, wendet Lifecycle-Regeln an und verwaltet das IAM. (Das aktuelle Proof of Concept nutzt `allUsers`, ist aber für einen sofortigen Wechsel auf Service Accounts via IAM ausgelegt).
* `outputs.tf`: Fängt die dynamisch generierten Ressourcen-IDs ab und liefert nach dem Deployment die klickbare Dashboard-URL direkt an das Terminal.
* `app/index.html`: Der HTML-Platzhalter ("Hello World") für das spätere Dashboard.

## 🚀 Deployment (Idempotenz)

Das Ausrollen erfolgt manuell-fehlerfrei, deklarativ und reproduzierbar über das Command Line Interface:
1. `gcloud auth application-default login` (Auth via OAUTH2, keine persistierten Secrets)
2. `terraform init`
3. `terraform plan` (Quality Assurance)
4. `terraform apply`

## 🔮 Ausblick: Erweiterung für den Produktivbetrieb

Für eine zukünftige Überführung der Architektur in eine echte Behördenumgebung sind folgende Schritte dieses "Blueprints" konzipiert:
1. **Zero-Trust (Google IAP):** Restriktion der Identitäten auf @polizei.bayern.de Accounts anstatt der derzeitigen öffentlichen Demonstrationsrechte.
2. **Serverless Backend (Cloud Functions):** Erweiterung der statischen Dateien um dynamische Datenbank-Schnittstellen (Cloud SQL).
3. **DevSecOps Automation:** Einbindung von Security-Scannern wie `tfsec` in eine GitHub Actions Pipeline für automatisierte Continuous Integration.