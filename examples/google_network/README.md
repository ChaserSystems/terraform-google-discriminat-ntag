# DiscrimiNAT, NTag architecture, alongside "terraform-google-modules/network/google" example

Demonstrates how to install DiscrimiNAT egress filtering in a network provisioned with the [terraform-google-modules/network/google](https://registry.terraform.io/modules/terraform-google-modules/network/google) module from the Terraform Registry.

## Example

See file `example.tf` in the _Source Code_ link above.

## External IPs

External IPs for the NAT function have been defined in a separate file, `eip.tf`, to encourage independent allocation and handling. Although the contents of `eip.tf` will be allocated if `terraform` is run in this directory, users should ensure External IPs are managed separately so they are not accidentally deleted.
