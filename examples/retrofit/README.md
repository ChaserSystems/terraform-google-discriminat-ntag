# DiscrimiNAT, NTag architecture, retrofit example

Demonstrates how to retrofit DiscrimiNAT egress filtering in a pre-existing VPC network, for a chosen region.

## Example

See file `example.tf` in the _Source Code_ link above.

## External IPs

External IPs for the NAT function have been defined in a separate file, `eip.tf`, to encourage independent allocation and handling. Although the contents of `eip.tf` will be allocated if `terraform` is run in this directory, users should ensure External IPs are managed separately so they are not accidentally deleted.

## Considerations

1. The network must already exist, otherwise the module will fail with `The argument "network" is required, but no definition was found.` errors.
1. The subnet in which the DiscrimiNAT is deployed must have [Private Google Access](https://cloud.google.com/vpc/docs/configure-private-google-access#enabling-pga) enabled.
