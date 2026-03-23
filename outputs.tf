output "website_url" {
  description = "Die öffentliche URL des Security Dashboards"
  value       = "[https://storage.googleapis.com/$](https://storage.googleapis.com/$){google_storage_bucket.static_site.name}/${var.index_document}"
}

output "log_bucket_name" {
  description = "Der Name des Audit-Log-Buckets"
  value       = google_storage_bucket.log_bucket.name

