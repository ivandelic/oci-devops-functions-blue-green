resource "oci_dns_zone" "zone" {
    compartment_id = var.compartment_ocid
    name = join(".", [var.dns_zone_name, var.dns_zone_parent])
    zone_type = "PRIMARY"
}

resource "oci_dns_rrset" "rrset" {
    domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
    rtype = "A"
    zone_name_or_id = oci_dns_zone.zone.id
    items {
        domain = join(".", [var.dns_zone_name, var.dns_zone_parent])
        rdata = oci_load_balancer_load_balancer.load_balancer.ip_address_details[0].ip_address
        rtype = "A"
        ttl = 30
    }
}