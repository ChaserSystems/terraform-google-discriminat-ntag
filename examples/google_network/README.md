# discrimiNAT, NTag architecture, alongside "terraform-google-modules/network/google" example

Demonstrates how to install discrimiNAT egress filtering in a network provisioned with the [terraform-google-modules/network/google](https://registry.terraform.io/modules/terraform-google-modules/network/google) module from the Terraform Registry.

## Example

See file `example.tf` in the _Source Code_ link above.

## Considerations

If creating the network and a discrimiNAT deployment at the same time, it may be useful to create just the network first so the discrimiNAT module has a clear idea of the setup. The following sequence of commands are specific to this example in order to resolve a `Invalid count argument` error message, should you encounter it.

1. `terraform apply -target=module.google_network`
1. `terraform apply`
