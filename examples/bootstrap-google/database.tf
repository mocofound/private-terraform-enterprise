resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "tfe-psql-db" {
  provider = "google-beta"
  name = "tfe-psql-db-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_9_6"
  region = "us-central1"
  depends_on = [
    "google_service_networking_connection.private_vpc_connection"
  ]
  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      private_network = "${module.firewall.google_compute_network_url}"
    }
  }
}

resource "google_sql_user" "tfe-psql-user" {
  name     = "${var.postgresql_user}"
  instance = "${google_sql_database_instance.tfe-psql-db.name}"
  host     = "me.com"
  password = "${var.postgresql_password}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = "google-beta"

  network       = "${module.firewall.google_compute_network_url}"
  service       = "servicenetworking.googleapis.com"
  #reserved_peering_ranges = []
  #reserved_peering_ranges = ["google-managed-services-${module.firewall.google_compute_network}"]
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

#provider "google-beta"{
#  region = "us-central1"
#  zone   = "us-central1-a"
#}

resource "google_compute_global_address" "private_ip_address" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 24
  network       = "${module.firewall.google_compute_network_url}"
}


resource "google_project_service" "service_networking_api" {
  project = "${var.project}"
  service = "servicenetworking.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}

resource "google_project_service" "cloud_resource_manager_api" {
  project = "${var.project}"
  service= "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
  disable_on_destroy = true
}

