provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.creds}"
  #credentials = "${file("${var.creds}")}"
}

provider "google-beta" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = ""${var.creds}"
  #credentials = "${file("${var.creds}")}"
}
