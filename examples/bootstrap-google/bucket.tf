resource "google_storage_bucket" "tfe-bucket" {
  name     = "tfe-storage-bucket"
  location = "us"

  #website {
  #  main_page_suffix = "index.html"
  #not_found_page   = "404.html"
  #}
}
