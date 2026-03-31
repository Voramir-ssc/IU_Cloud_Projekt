# Schaerl Security Solutions - Cloud-Infrastruktur

**Modul:** Cloud Programming  
**Studierender:** Stefan Schaerl  
**Dozent:** Prof. Dr. T. Lu  

---

## 1. Einführung: Anforderungsanalyse und Ziele

### 1.1 Problemabgrenzung und Kontext der behördlichen IT
Die fortschreitende Digitalisierung in der behördlichen Ermittlungsarbeit erfordert hochverfügbare, skalierbare und vor allem extrem sichere IT-Infrastrukturen. Dieses Projekt fungiert als **Proof of Concept (PoC)** für eine cloudbasierte Architektur, die speziell auf die restriktiven und hochsensiblen Anforderungen der Polizeiverwaltung und der IT-Forensik zugeschnitten ist.

Die Cloud löst hierbei die fundamentale Inflexibilität herkömmlicher lokaler Serverstrukturen (On-Premises), die bei polizeilichen Großlagen oft an ihre Kapazitätsgrenzen (Denial of Service) stoßen. Die Implementierung erfordert jedoch die Lösung hochkomplexer architektonischer Fragen bezüglich Datenlokalität (Data Sovereignty), Zugriffssicherheit (Zero-Trust-Konzepte) und BSI-Vorgaben.

### 1.2 Zielsetzung des Projekts
Ziel ist die Konzeption, Automatisierung und Bereitstellung einer serverlosen Cloud-Infrastruktur, die ein initiales "Hello World"-Security-Dashboard sicher hostet. Dieses Dashboard repräsentiert die technologische Basis für zukünftige dynamische Statusabfragen von forensischen Berichten. Der Fokus liegt vollständig auf der Schaffung eines soliden, nach "Security by Design"-Prinzipien entwickelten Backend- und Infrastruktur-Fundaments.

### 1.3 Explizite Entscheidungskriterien
* **Sicherheit und DSGVO:** Der Serverstandort in Deutschland ist für Ermittlungsakten zwingend (Data Sovereignty). Zugriffe erfordern ein robustes IAM und forensisch lückenloses Audit Logging.
* **Hohe Verfügbarkeit & Automatische Skalierung:** Nutzung von Serverless-Technologien zum Abfangen unvorhersehbarer Traffic-Spitzen und "Scale-to-Zero" bei absoluter Inaktivität.
* **Wirtschaftlichkeit (FinOps):** Reduktion der laufenden Betriebskosten im Prototypen-Stadium auf exakt 0,00 € durch intelligente Nutzung von Cloud-Free-Tiers.
* **Reproduzierbarkeit (IaC):** Vollständig deklarative Infrastruktur als Code (Terraform), um manuelle Interaktionen in grafischen Konsolen ("ClickOps") und damit einhergehende Fehler- und Sicherheitsrisiken rigoros auszuschließen.

---

## 2. Architektur und Plattformauswahl

### 2.1 Plattformauswahl: Google Cloud Platform (GCP)
Nach systematischer Evaluierung alternativer Plattformen (Microsoft Azure aufgrund von harten Vendor Lock-ins und intransparenten Governance-Policies verworfen; AWS S3 + CloudFront als zu komplex und potenziell zu teuer für den spezifischen Anwendungsfall eingestuft) fiel die Wahl auf die **Google Cloud Platform**.
* **Cloud Storage Hosting:** Natives, hochperformantes und serverloses Hosting für statische Webseiten direkt über `storage.googleapis.com` inklusive von Google vollautomatisiert gemanagter HTTPS-Verschlüsselung.
* **Datenlokalität:** Die Region `europe-west3` (Frankfurt) garantiert rechtliche DSGVO-Konformität und ist im GCP Free-Tier nativ und kostenlos verfügbar.
* **Hervorragendes IaC-Tooling:** Der offizielle Terraform-Provider (`hashicorp/google`) bietet eine extrem performante, fehlerfreie Integration und ermöglichte eine schnelle, agile Migration von dem gescheiterten Azure-Konzept zur GCP.

### 2.2 Cloud-Architektur und Komponenten-Zusammenspiel
Die Architektur trennt strikt zwischen Bereitstellungsebene (Entwickler über lokales Terraform CLI) und Zugriffsebene (Endnutzer über Internet).
* Ein dedizierter **Audit-Log-Bucket** zur forensischen Protokollierung.
* Ein primärer **Web-Bucket** für das Hosting der Dashboard-Dateien inklusive konfigurierter Lebenszyklus-Richtlinien.
* Lückenlose, manipulationssichere Zugriffsverifikation und -protokollierung im Millisekundenbereich durch das GCP IAM-Backend.

---

## 3. Reproduzierbares Deployment und Struktur der IaC-Codebasis

Gemäß den "Google Cloud Security Best Practices" wurde der deklarative Code nicht monolithisch verfasst, sondern in drei logische Kernmodule strukturiert:

### 3.1 `variables.tf` (Parametrisierung)
Das Konfigurations-Interface der Infrastruktur. Authentifizierung geschieht sicher via lokaler OAUTH2-Tokens, feste Hardcodes von Passwörtern sind verboten. Die voreingestellte Region `europe-west3` manifestiert das Prinzip "Security by Design". Tagging (`owner`, `project`, `environment`) sichert Best Practices aus dem FinOps-Bereich.

### 3.2 `main.tf` (Architektonische Logik und Security)
Das Herzstück überträgt Compliance-Vorgaben in Cloud-Ressourcen:
1. **Audit-Log-Bucket:** Isolierter Speicher ausschließlich für forensische Logs.
2. **Primärer Web-Bucket:** Geschützt durch `uniform_bucket_level_access` (blockiert individuelle Freigaben) und eine Dateiversionierung (Schutz vor Ransomware-Verschlüsselung). Eine intelligente `lifecycle_rule` löscht Objekte automatisiert nach 30 Tagen zur Kostenminimierung.
3. **IAM:** Definition der Zugriffsschranken. Für das Proof-of-Concept-Dashboard ist der pure Lesezugriff zur Demonstration auf `allUsers` geschaltet. Für den Behördeneinsatz ist das System durch den Austausch dieses Strings gegen spezifische Service Accounts sofort hermetisch abgeriegelt.

### 3.3 `outputs.tf` (Rückgabewerte)
Fängt dynamisch generierte, weltweit einzigartige Bucket-IDs zur Laufzeit ab und gibt sie als klickbare HTTPS-URL strukturiert im lokalen Terminal aus – für eine sofortige visuelle Verifikation ohne Login in die Web-Konsole.

### 3.4 Reproduzierbare Deployment-Schritte
Das System folgt dem Paradigma der "Idempotenz":
1. `gcloud auth application-default login` – Sichere Authentifizierung
2. `terraform init` – Herunterladen abhängiger Provider-Binaries (Hashicorp Google)
3. `terraform plan` – Evaluierung des DAGs (Directed Acyclic Graph) und Quality Assurance
4. `terraform apply` – Cloud API-Ansteuerung und physische Bereitstellung der definierten Infrastruktur in wenigen Sekunden.

---

## 4. Zusammenfassung und Zukunftsblick

Dieses Proof-of-Concept demonstriert eindrucksvoll den Wert agiler Cloud-Engineering-Methoden und liefert ein hochverfügbares, DSGVO-konformes und kosteneffizientes Dashboard für "Schaerl Security Solutions". Die IaC-Basis agiert als hochgradig modularer "*Blueprint*" für zukünftige polizeiliche Bereitstellungen und zeichnet sich durch Security by Design aus.

**Transferfähigkeit und Ausbaustufen für Phase 4:**
1. **Zero-Trust Identity Management:** Ablösung von `allUsers` und Einführung des **Google Identity-Aware Proxy (IAP)**. Nur noch verifizierte Cloud Identity Accounts (z. B. `@polizei.bayern.de`) erhalten token-basierten Zugang.
2. **Dynamische Backend-Anbindung (FaaS):** Transformation des Dashboards zur dynamischen Applikation durch **Google Cloud Functions**, um verschlüsselte Analysedatenbanken (z. B. Cloud SQL) abzufragen.
3. **DevSecOps Pipeline-Integration:** Verlagerung des manuellen CLI-Deployments in **GitHub Actions**, um vollautomatisierte Infrastruktur-Sicherheitstests (z. B. via `tfsec`) bei jedem Git-Commit zu etablieren.