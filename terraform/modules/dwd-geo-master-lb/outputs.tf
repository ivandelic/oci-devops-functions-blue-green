output "apigateway_fqdn" {
  value = oci_dns_zone.zone.name
}

output "load_balancer_id" {
  value = oci_load_balancer_load_balancer.load_balancer.id
}

output "load_balancer_backendset_name" {
  value = oci_load_balancer_backend_set.backend_set.name
}