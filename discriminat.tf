## Inputs

variable "subnetwork_name" {
  type        = string
  description = "The name of the subnetwork to deploy the discrimiNAT firewall instances in. This must already exist."
}

variable "region" {
  type        = string
  description = "The region the specified subnetwork is to be found in."
}

##

## Defaults

variable "external_ip_addresses" {
  type        = list(string)
  description = "Specific, pre-allocated external IP addresses if you wish to use these for egress, NATed traffic. If none specified, ephemeral external IP addressess will be allocated automatically. If specifed, should be equal to the number of zones and NOT be associated with other instances or NAT solutions."
  default     = []
}

variable "zones_names" {
  type        = list(string)
  description = "Specific zones if you wish to override the default behaviour. If not overridden, defaults to all zones found in the specified region."
  default     = []
}

variable "labels" {
  type        = map(any)
  description = "Map of key-value label pairs to apply to resources created by this module. See examples for use."
  default     = {}
}

variable "machine_type" {
  type        = string
  description = "The default of e2-small should suffice for light to medium levels of usage. Anything less than 2 CPU cores and 2 GB of RAM is not recommended. For faster access to the Internet and for projects with a large number of VMs, you may want to choose a machine type with more CPU cores."
  default     = "e2-small"
}

variable "block-project-ssh-keys" {
  type        = bool
  description = "Strongly suggested to leave this to the default, that is to NOT allow project-wide SSH keys to login into the firewall."
  default     = true
}

variable "startup_script_base64" {
  type        = string
  description = "Strongly suggested to NOT run custom, startup scripts on the firewall instances. But if you had to, supply a base64 encoded version here."
  default     = ""
}

##

## Lookups

data "google_compute_subnetwork" "context" {
  name   = var.subnetwork_name
  region = var.region
}

data "google_compute_zones" "auto" {
  region = var.region
}

data "google_compute_image" "discriminat" {
  family  = "discriminat"
  project = "chasersystems-public"
}

##

## Compute

resource "google_compute_address" "discriminat" {
  count = length(local.zones)

  region     = var.region
  subnetwork = var.subnetwork_name

  name         = "discriminat-${local.zones[count.index]}"
  address_type = "INTERNAL"
}

resource "google_compute_instance_template" "discriminat" {
  count = length(local.zones)

  name_prefix = "discriminat-${local.zones[count.index]}-"
  lifecycle {
    create_before_destroy = true
  }

  region = var.region

  tags           = ["discriminat-itself"]
  machine_type   = var.machine_type
  can_ip_forward = true

  metadata_startup_script = var.startup_script_base64 == "" ? null : base64decode(var.startup_script_base64)

  metadata = {
    block-project-ssh-keys = var.block-project-ssh-keys
  }

  disk {
    source_image = data.google_compute_image.discriminat.self_link
    disk_type    = "pd-ssd"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = var.subnetwork_name
    network_ip = google_compute_address.discriminat[count.index].address
    access_config {
      nat_ip = length(var.external_ip_addresses) > 0 ? var.external_ip_addresses[count.index] : null
    }
  }

  service_account {
    scopes = ["compute-ro", "logging-write", "monitoring-write"]
  }

  labels = local.labels
}

resource "google_compute_health_check" "discriminat" {
  name = "discriminat-${var.region}"

  healthy_threshold   = 2
  unhealthy_threshold = 2
  check_interval_sec  = 2
  timeout_sec         = 2

  http_health_check {
    port = 1042
  }
}

resource "google_compute_instance_group_manager" "discriminat" {
  count = length(local.zones)

  name               = "discriminat-${local.zones[count.index]}"
  base_instance_name = "discriminat"
  target_size        = 1

  zone = local.zones[count.index]

  wait_for_instances = true

  version {
    instance_template = google_compute_instance_template.discriminat[count.index].id
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.discriminat.id
    initial_delay_sec = 120
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = 1
    max_unavailable_fixed = 1
  }
}

##

## VPC

resource "google_compute_route" "discriminat" {
  count = length(local.zones)

  name        = "discriminat-${local.zones[count.index]}"
  tags        = ["discriminat-${local.zones[count.index]}"]
  dest_range  = "0.0.0.0/0"
  network     = data.google_compute_subnetwork.context.network
  next_hop_ip = google_compute_address.discriminat[count.index].address
  priority    = 200
}

resource "google_compute_firewall" "discriminat-to-internet" {
  name    = "discriminat-${var.region}-to-internet"
  network = data.google_compute_subnetwork.context.network

  direction = "EGRESS"
  priority  = 200

  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["discriminat-itself"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "discriminat-from-healthcheckers" {
  name    = "discriminat-${var.region}-from-healthcheckers"
  network = data.google_compute_subnetwork.context.network

  direction = "INGRESS"
  priority  = 200

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["discriminat-itself"]

  allow {
    protocol = "tcp"
    ports    = [1042]
  }
}

resource "google_compute_firewall" "discriminat-from-clients" {
  name    = "discriminat-${var.region}-from-clients"
  network = data.google_compute_subnetwork.context.network

  direction = "INGRESS"
  priority  = 200

  target_tags   = ["discriminat-itself"]
  source_ranges = [data.google_compute_subnetwork.context.ip_cidr_range]

  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "discriminat-from-rest" {
  name    = "discriminat-${var.region}-from-rest"
  network = data.google_compute_subnetwork.context.network

  direction = "INGRESS"
  priority  = 400

  target_tags   = ["discriminat-itself"]
  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }
}

##

## Locals

locals {
  labels = merge(
    {
      "product" : "discriminat",
      "vendor" : "chasersystems_com"
    },
    var.labels
  )
}

locals {
  zones = length(var.zones_names) > 0 ? var.zones_names : data.google_compute_zones.auto.names
}

##

## Outputs

output "zonal_network_tags" {
  value       = { for z in local.zones : z => "discriminat-${z}" }
  description = "Network Tags – to be associated with protected applications – for filtering traffic through the nearest discrimiNAT firewall instance."
}

##
