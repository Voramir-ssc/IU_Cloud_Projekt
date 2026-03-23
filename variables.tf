variable "project_id" {
  description = "Die Google Cloud Project ID"
  type        = string
  default     = "schaerl-security-cloud"
}

variable "region" {
  description = "Serverstandort (DSGVO-konform)"
  type        = string
  default     = "europe-west3"
}

variable "bucket_name_prefix" {
  description = "Prefix für den weltweit eindeutigen Bucket-Namen"
  type        = string
  default     = "schaerl-sec-dash"
}

variable "index_document" {
  description = "Die Startseite der Applikation"
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "Metadaten / Tags für Ressourcen-Management"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "schaerl-security"
    owner       = "it-forensik"
  }
}

