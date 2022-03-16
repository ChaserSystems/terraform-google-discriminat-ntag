resource "google_compute_address" "nat_a" {
  provider = google-beta

  name = "static-egress-ip-a"

  address_type = "EXTERNAL"

  region  = module.google_network.subnets["europe-west2/subnet-foo"].region
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

  region  = module.google_network.subnets["europe-west2/subnet-foo"].region
  project = var.project_id

  labels = {
    "discriminat" = "any-remark"
  }

  lifecycle {
    prevent_destroy = false
  }
}
