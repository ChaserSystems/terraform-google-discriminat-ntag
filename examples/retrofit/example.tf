variable "project_id" {
  type        = string
  description = "The GCP Project ID for this deployment. For example: my-project-111222"
}

module "discriminat" {
  source = "ChaserSystems/discriminat-ntag/google"

  project_id      = var.project_id
  subnetwork_name = "my-subnetwork"
  region          = "europe-west2"

  client_cidrs = ["10.11.12.0/28"]

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }
}

output "zonal_network_tags" {
  value       = module.discriminat.zonal_network_tags
  description = "Network Tags – to be associated with protected applications – for filtering traffic through the nearest discrimiNAT firewall instance."
}
