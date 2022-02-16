provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "dwd_geo_fn" {
  source                                = "../../../modules/dwd-geo-fn"
  compartment_ocid                      = var.compartment_ocid
  color                                 = "green"
  subnet_id                             = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanfk5lre5s75ax42hexvpcxb67vbb4kf3obycmb3ixinzkb3e5lcq"
  application_display_name              = "app-dwd-geo"
  function_display_name                 = "fn-api-retriever"
  function_image                        = "fra.ocir.io/frylmu0i5png/dwd/api-retriever:0.0.6"
  function_memory                       = "256"
  gateway_display_name                  = "gw-dwd-geo"
  deployment_display_name               = "dpl-dwd-geo"
  deployment_path_prefix                = "/geo"
  deployment_http_methods_api_retriever = ["POST"]
  deployment_route_path_api_retriever   = "/api-retriever"
  deployment_http_methods_frontend      = ["GET"]
  deployment_route_path_frontend        = "/portal"
  dns_zone_name                         = "dwd"
  dns_zone_parent                       = "ivandelic.com"
}
