resource "oci_identity_dynamic_group" "coderepo_dynamic_group" {
    compartment_id = var.tenancy_ocid
    description = "Dynamic group for DevOps Code Repository"
    matching_rule = "All {resource.type = 'devopsrepository', resource.compartment.id = '${var.compartment_ocid}'}" 
    name = var.coderepo_dynamic_group_name
}

resource "oci_identity_dynamic_group" "build_dynamic_group" {
    compartment_id = var.tenancy_ocid
    description = "Dynamic group for DevOps Build Pipeline"
    matching_rule = "All {resource.type = 'devopsbuildpipeline', resource.compartment.id = '${var.compartment_ocid}'}" 
    name = var.build_dynamic_group_name
}

resource "oci_identity_dynamic_group" "deploy_dynamic_group" {
    compartment_id = var.tenancy_ocid
    description = "Dynamic group for DevOps Deploy Pipeline"
    matching_rule = "All {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}" 
    name = var.deploy_dynamic_group_name
}

resource "oci_identity_dynamic_group" "functions_dynamic_group" {
    compartment_id = var.tenancy_ocid
    description = "Dynamic group for Functions to call other services"
    matching_rule = "All {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"
    name = var.functions_dynamic_group_name
}

resource "oci_identity_policy" "devops_general_policy" {
    compartment_id = var.compartment_ocid
    description = "General policy for DevOps service "
    name = var.devops_general_policy_name
    statements = [
      "Allow dynamic-group ${oci_identity_dynamic_group.coderepo_dynamic_group.name} to manage devops-family in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to read secret-family in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage devops-family in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage repos in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage generic-artifacts in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to use ons-topics in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to read secret-family in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage repos in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to use artifact-repositories in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage generic-artifacts in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.build_dynamic_group.name} to manage all-artifacts in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.deploy_dynamic_group.name} to manage all-resources in compartment ${var.compartment_name}",
      "Allow dynamic-group ${oci_identity_dynamic_group.functions_dynamic_group.name} to manage all-resources in compartment ${var.compartment_name}",
      "Allow any-user to use functions-family in compartment ${var.compartment_name} where ALL {request.principal.type= 'ApiGateway', request.resource.compartment.id = '${var.compartment_ocid}'}"
    ]
}