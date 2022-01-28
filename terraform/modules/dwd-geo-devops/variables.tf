# general
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "compartment_name" {}

# naming
variable "coderepo_dynamic_group_name" {}
variable "build_dynamic_group_name" {}
variable "deploy_dynamic_group_name" {}
variable "devops_general_policy_name" {}
variable "devops_notification_topic_name" {}
variable "devops_notification_subscription_endpoint_email" {}
variable "devops_notification_subscription_endpoint_slack" {}
variable "devops_project_name" {}
variable "devops_repository_name" {}
variable "devops_build_pipeline_name" {}
variable "devops_deploy_pipeline_name" {}
variable "artifact_repository_name" {}
variable "container_image_path" {}
variable "arifact_build_spec_fn_image" {}