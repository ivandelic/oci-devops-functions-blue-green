#resource "oci_dns_zone" "zone" {
#    compartment_id = var.compartment_ocid
#    name = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
#    zone_type = "PRIMARY"
#}

data "oci_dns_zones" "dwd-hub_zone" {
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    name = var.dns_zone_parent
}

resource "oci_dns_rrset" "rrset" {
    domain = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
    rtype = "A"
    zone_name_or_id = data.oci_dns_zones.dwd-hub_zone.name
    items {
        domain = join(".", [join("-", [var.dns_zone_name, var.color]), var.dns_zone_parent])
        rdata = oci_apigateway_gateway.apigateway_gateway.ip_addresses[0].ip_address
        rtype = "A"
        ttl = 30
    }
}