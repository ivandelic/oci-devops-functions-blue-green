resource "oci_dns_zone" "zone" {
    compartment_id = var.compartment_ocid
    name = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
    zone_type = "PRIMARY"
}

resource "oci_dns_rrset" "rrset" {
    domain = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
    rtype = "A"
    zone_name_or_id = oci_dns_zone.zone.id
    items {
        domain = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
        rdata = oci_apigateway_gateway.apigateway_gateway.ip_addresses[0].ip_address
        rtype = "A"
        ttl = 30
    }
}