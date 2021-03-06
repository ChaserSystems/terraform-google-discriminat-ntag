# discrimiNAT, NTag architecture

[discrimiNAT firewall](https://chasersystems.com/discrimiNAT/) for egress filtering by FQDNs on Google Cloud. Just specify the allowed destination hostnames in the applications' native Firewall Rules and the firewall will take care of the rest.

**Architecture with Network Tags in VPCs for fine-grained, opt-in control over routing.**

[Demo Videos](https://chasersystems.com/discrimiNAT/demo/) | [discrimiNAT FAQ](https://chasersystems.com/discrimiNAT/faq/)

## Highlights

* Utilises Network Tags in VPCs for fine-grained, opt-in control over routing.
* Can accommodate pre-allocated external IPs for use with the NAT function. Making use of this is of course, optional.
* VMs _without_ public IPs will need firewall rules specifying what egress FQDNs and protocols are to be allowed. Default behaviour is to deny everything.

## Considerations

* Only one deployment per zone is advised.
* VMs _without_ public IPs will need a network tag (output by this module) to access the Internet at all.
* You must be subscribed to the [discrimiNAT firewall from the Google Cloud Marketplace](https://console.cloud.google.com/marketplace/details/chasersystems-public/discriminat?utm_source=gthb&utm_medium=dcs&utm_campaign=trrfrm).

## Next Steps

* [Understand how to configure the enhanced Firewall Rules](https://chasersystems.com/discrimiNAT/gcp/quick-start/#v-firewall-rules) after deployment from our main documentation.
* Contact our DevSecOps at devsecops@chasersystems.com for queries at any stage of your journey.

## Alternatives

* For an architecture with internal TCP load balancers as next hops set as the default, and tag based opt-out control, see the [ILB module](https://registry.terraform.io/modules/ChaserSystems/discriminat-ilb/google/).
