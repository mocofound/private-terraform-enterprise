resource "google_sql_database_instance" "tfe-psql-db" {
  name = "tfe-psql-db-instance"
  database_version = "POSTGRES_9_6"
  region = "us-central1"
  #depends_on = [
  #  "module.firewall.google_service_networking_connection.ptfe_vpc"
  #]
  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      private_network = "module.firewall.google_compute_network.ptfe_vpc.self_link"
    }
  }
}

resource "google_sql_user" "tfe-psql-user" {
  name     = "${var.postgresql_user}"
  instance = "${google_sql_database_instance.tfe-psql-db.name}"
  host     = "me.com"
  password = "${var.postgresql_password}"
}
