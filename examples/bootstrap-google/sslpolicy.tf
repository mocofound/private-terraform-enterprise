resource "google_compute_ssl_policy" "tfe-ssl-policy" {
  name    = "tfe-ssl-policy"
  profile = "MODERN"
}
