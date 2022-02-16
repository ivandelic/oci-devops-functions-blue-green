provider "oci" {
  region = var.region
}

module "dwd_geo_fn" {
  source                                = "../../../modules/dwd-geo-fn"
  compartment_ocid                      = var.compartment_ocid
  color                                 = "blue"
  subnet_id                             = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanfk5lre5s75ax42hexvpcxb67vbb4kf3obycmb3ixinzkb3e5lcq"
  application_display_name              = "app-dwd-geo"
  function_display_name                 = "fn-api-retriever"
  function_image                        = "fra.ocir.io/frylmu0i5png/dwd/api-retriever:latest"
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
  load_balancer_backendset_name         = var.load_balancer_backendset_name
  load_balancer_id                      = var.load_balancer_id
}

output "dwd_geo_fn_apigateway_ip" {
  value = module.dwd_geo_fn.apigateway_external_ip
}

output "dwd_geo_fn_apigateway_fqdn" {
  value = module.dwd_geo_fn.apigateway_fqdn
}
