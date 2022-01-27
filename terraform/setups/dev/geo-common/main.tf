provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "dwd_geo_master_lb" {
  source = "../../../modules/dwd-geo-master-lb"
  compartment_ocid = var.compartment_ocid
  name = "dwd-geo-module"
  subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanfk5lre5s75ax42hexvpcxb67vbb4kf3obycmb3ixinzkb3e5lcq"
  apigateway_ip_blue    = "141.144.233.128"
  apigateway_port_blue  = 443
  apigateway_ip_green   = "	144.24.182.173"
  apigateway_port_green = 443
  dns_zone_name   = "dwd-module"
  dns_zone_parent = "ivandelic.com"
}