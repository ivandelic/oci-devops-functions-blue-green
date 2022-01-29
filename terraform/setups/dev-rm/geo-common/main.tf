provider "oci" {
  region = var.region
}

module "dwd_geo_master_lb" {
  source                    = "../../../modules/dwd-geo-master-lb"
  compartment_ocid          = var.compartment_ocid
  name                      = "dwd-geo"
  subnet_id                 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanfk5lre5s75ax42hexvpcxb67vbb4kf3obycmb3ixinzkb3e5lcq"
  apigateway_ip_blue        = var.apigateway_ip_blue
  apigateway_port_blue      = var.apigateway_port_blue
  apigateway_ip_green       = var.apigateway_ip_green
  apigateway_port_green     = var.apigateway_port_green
  dns_zone_name             = "dwd"
  dns_zone_parent           = "ivandelic.com"
  dns_initial_cname_pointer = "dwd-blue.ivandelic.com"
}

output "dwd_geo_master_lb_fqdn" {
  value = module.dwd_geo_master_lb.apigateway_fqdn
}