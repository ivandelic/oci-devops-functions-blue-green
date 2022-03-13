provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "dwd_geo_devops" {
  source                                          = "../../../modules/dwd-geo-devops"
  tenancy_ocid                                    = var.tenancy_ocid
  compartment_name                                = "difu_devops"
  compartment_ocid                                = var.compartment_ocid
  coderepo_dynamic_group_name                     = "CoderepoDynamicGroupDWD"
  build_dynamic_group_name                        = "BuildDynamicGroupDWD"
  deploy_dynamic_group_name                       = "DeployDynamicGroupDWD"
  functions_dynamic_group_name                    = "FunctionsDynamicGroupDWD"
  devops_general_policy_name                      = "DevOpsDWD"
  devops_notification_topic_name                  = "dwd-geo-notifications"
  devops_notification_subscription_endpoint_email = var.devops_notification_subscription_endpoint_email
  devops_notification_subscription_endpoint_slack = var.devops_notification_subscription_endpoint_slack
  devops_project_name                             = "dwd-geo-devops"
  devops_repository_name                          = "dwd-geo-repo"
  devops_build_pipeline_name                      = "dwd-geo-build-pipeline"
  devops_deploy_pipeline_name                     = "dwd-geo-deploy-pipeline"
  artifact_repository_name                        = "dwd-geo-artifact-repo"
  container_image_path                            = "eu-frankfurt-1.ocir.io/frylmu0i5png/dwd/"
  arifact_true_fn_image_name                      = "api-retriever"
  arifact_build_spec_fn_image_latest              = "api-retriever-latest"
  arifact_build_spec_fn_image_specific            = "api-retriever-specific"
  fn_dns_switch_id                                = "ocid1.fnfunc.oc1.eu-frankfurt-1.aaaaaaaaeitoibery3w45kr6qegdacppmbz2ow3ymuia5qbkcdhxiwaa6aza"
  fn_resource_manager_trigger_id                  = "ocid1.fnfunc.oc1.eu-frankfurt-1.aaaaaaaa6rq3g37vw56myp366jxecoopx3i4zcshlmhiehltkn4xipvasjva"
  arifact_build_spec_fn_payload                   = "fn-integration-payload"
}