module "discriminat" {
  source = "ChaserSystems/discriminat-ntag/google"

  subnetwork_name = "my-subnetwork"
  region          = "europe-west2"

  labels = {
    "x"   = "y"
    "foo" = "bar"
  }
}
