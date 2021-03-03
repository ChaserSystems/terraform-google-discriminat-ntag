# discrimiNAT, NTag architecture

## Highlights

* Utilises Network Tags in VPCs for fine-grained, opt-in control over routing.
* Can accommodate pre-allocated external IPs for use with the NAT function. Making use of this is of course, optional.
* VMs _without_ public IPs will need firewall rules specifying what egress FQDNs and protocols are to be allowed. Default behaviour is to deny everything.


## Considerations

* Only one deployment per zone is advised.
* VMs _without_ public IPs will need a network tag (output by this module) to access the Internet at all.
