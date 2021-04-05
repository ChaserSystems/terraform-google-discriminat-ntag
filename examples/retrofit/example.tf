module "discriminat" {
  source = "ChaserSystems/discriminat-ntag/google"

  subnetwork_name = "my-subnetwork"
  region          = "europe-west2"

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }
}

output "zonal_network_tags" {
  value       = module.discriminat.zonal_network_tags
  description = "Network Tags — to be associated with protected applications — for filtering traffic through the nearest discrimiNAT firewall instance."
}
