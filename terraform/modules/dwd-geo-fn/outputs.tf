output "apigateway_external_ip" {
  value = oci_apigateway_gateway.apigateway_gateway.ip_addresses[0].ip_address
}

output "apigateway_fqdn" {
  value = oci_dns_zone.zone.name
}