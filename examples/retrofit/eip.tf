resource "google_compute_address" "nat_a" {
  provider = google-beta

  name = "static-egress-ip-a"

  address_type = "EXTERNAL"

  region  = "europe-west2"
  project = var.project_id

  labels = {
    "discriminat" = "some-comment"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_compute_address" "nat_b" {
  provider = google-beta

  name = "static-egress-ip-b"

  address_type = "EXTERNAL"

  region  = "europe-west2"
  project = var.project_id

  labels = {
    "discriminat" = "any-remark"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_compute_address" "nat_c" {
  provider = google-beta

  name = "static-egress-ip-c"

  address_type = "EXTERNAL"

  region  = "europe-west2"
  project = var.project_id

  labels = {
    "discriminat" = "whatsoever"
  }

  lifecycle {
    prevent_destroy = false
  }
}
