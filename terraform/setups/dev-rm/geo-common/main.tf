provider "oci" {
  region = var.region
}

module "dwd_geo_master_lb" {
  source                    = "../../../modules/dwd-geo-master-lb"
  compartment_ocid          = var.compartment_ocid
  name                      = "dwd-geo"
  subnet_id                 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanfk5lre5s75ax42hexvpcxb67vbb4kf3obycmb3ixinzkb3e5lcq"
  dns_zone_name             = "geo"
  dns_zone_parent           = "dwd-hub.de"
  dns_initial_cname_pointer = var.dns_initial_cname_pointer
}

output "dwd_geo_master_lb_fqdn" {
  value = module.dwd_geo_master_lb.apigateway_fqdn
}

output "load_balancer_id" {
  value = module.dwd_geo_master_lb.load_balancer_id
}

output "load_balancer_backendset_name" {
  value = module.dwd_geo_master_lb.load_balancer_backendset_name
}