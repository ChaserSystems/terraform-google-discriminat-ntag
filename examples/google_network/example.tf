variable "project_id" {
  type        = string
  description = "The GCP Project ID for this deployment. For example: my-project-111222"
}

module "google_network" {
  source  = "terraform-google-modules/network/google"
  version = "> 3, < 4"

  network_name = "discriminat-example"
  project_id   = var.project_id

  subnets = [
    {
      subnet_name           = "subnet-foo"
      subnet_ip             = "192.168.101.0/24"
      subnet_region         = "europe-west2"
      subnet_private_access = true
    }
  ]
}

module "discriminat" {
  source = "ChaserSystems/discriminat-ntag/google"

  project_id      = var.project_id
  subnetwork_name = module.google_network.subnets["europe-west2/subnet-foo"].name
  region          = module.google_network.subnets["europe-west2/subnet-foo"].region

  client_cidrs = ["10.11.12.0/28"]

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }

  zones_names = ["europe-west2-a", "europe-west2-b"] # delete or set to [] for all zones

  depends_on = [module.google_network]
}

output "zonal_network_tags" {
  value       = module.discriminat.zonal_network_tags
  description = "Network Tags – to be associated with protected applications – for filtering traffic through the nearest discrimiNAT firewall instance."
}
