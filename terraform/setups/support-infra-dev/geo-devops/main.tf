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
  compartment_name                                = "ivan.delic"
  compartment_ocid                                = var.compartment_ocid
  coderepo_dynamic_group_name                     = "CoderepoDynamicGroupDWD"
  build_dynamic_group_name                        = "BuildDynamicGroupDWD"
  deploy_dynamic_group_name                       = "DeployDynamicGroupDWD"
  devops_general_policy_name                      = "DevOpsDWD"
  devops_notification_topic_name                  = "dwd-geo-notifications"
  devops_notification_subscription_endpoint_email = "ivan.delic@gmail.com"
  devops_notification_subscription_endpoint_slack = "https://hooks.slack.com/services/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"
  devops_project_name                             = "dwd-geo-devops"
  devops_repository_name                          = "dwd-geo-repo"
  devops_build_pipeline_name                      = "dwd-geo-build-pipeline"
  devops_deploy_pipeline_name                     = "dwd-geo-deploy-pipeline"
  artifact_repository_name                        = "dwd-geo-artifact-repo"
  container_image_path                            = "eu-frankfurt-1.ocir.io/frsxwtjslf35/dwd/"
  arifact_build_spec_fn_image                     = "api-retriever"
  resource_manager_trigger_function_id            = var.resource_manager_trigger_function_id
  arifact_build_spec_fn_payload                   = "resource-manager-trigger-payload"
}
