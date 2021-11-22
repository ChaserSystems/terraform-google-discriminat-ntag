module "google_network" {
  source  = "terraform-google-modules/network/google"
  version = "> 3, < 4"

  network_name = "my-network"
  project_id   = "my-project-123456"

  subnets = [
    {
      subnet_name   = "my-subnet"
      subnet_ip     = "192.168.101.0/24"
      subnet_region = "europe-west2"
    }
  ]
}

module "discriminat" {
  for_each = module.google_network.subnets

  source = "ChaserSystems/discriminat-ntag/google"

  subnetwork_name = each.value.name
  region          = each.value.region

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }

  depends_on = [module.google_network]
}

output "zonal_network_tags" {
  value       = module.discriminat["europe-west2/my-subnet"].zonal_network_tags
  description = "Network Tags – to be associated with protected applications – for filtering traffic through the nearest discrimiNAT firewall instance."
}
