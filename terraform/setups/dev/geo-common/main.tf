provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "dwd_geo_master_lb" {
  source                    = "../../../modules/dwd-geo-master-lb"
  compartment_ocid          = var.compartment_ocid
  name                      = "dwd-geo"
  subnet_id                 = var.lb_subnet_id
  dns_zone_name             = "geo"
  dns_zone_parent           = "dwd-hub.de"
  dns_initial_cname_pointer = var.dns_initial_cname_pointer
}