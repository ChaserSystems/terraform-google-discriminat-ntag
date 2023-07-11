variable "project_id" {
  type        = string
  description = "The GCP Project ID for this deployment. For example: my-project-111222"
}

module "discriminat" {
  source = "ChaserSystems/discriminat-ntag/google"

  project_id      = var.project_id
  subnetwork_name = "my-subnetwork"
  region          = "europe-west2"

  #random_deployment_id = true

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }
}

output "zonal_network_tags" {
  value       = module.discriminat.zonal_network_tags
  description = "Network Tags – to be associated with protected applications – for filtering traffic through the nearest DiscrimiNAT Firewall instance."
}

output "deployment_id" {
  value       = module.discriminat.deployment_id
  description = "In case random_deployment_id was set to true, this is the unique, randomised ID for this deployment that forms a part of the resource names."
}
