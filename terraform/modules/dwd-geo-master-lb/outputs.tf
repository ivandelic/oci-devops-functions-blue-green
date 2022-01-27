output "apigateway_fqdn" {
  value = oci_dns_zone.zone.name
}