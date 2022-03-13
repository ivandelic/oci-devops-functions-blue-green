output "apigateway_external_ip" {
  value = oci_apigateway_gateway.apigateway_gateway.ip_addresses[0].ip_address
}

