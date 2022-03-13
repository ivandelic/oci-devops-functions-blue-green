output "apigateway_fqdn" {
  value = data.oci_dns_zones.dwd-hub_zone.name
}

