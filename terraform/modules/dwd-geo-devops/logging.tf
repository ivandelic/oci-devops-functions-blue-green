resource "oci_logging_log_group" "log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "devops_log_group_${oci_devops_project.devops_project.name}"
}

resource "oci_logging_log" "log" {
  display_name = "devops_log_group_${oci_devops_project.devops_project.name}_log"
  log_group_id = oci_logging_log_group.log_group.id
  log_type     = "SERVICE"
  configuration {
    source {
      category    = "all"
      resource    = oci_devops_project.devops_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }
    compartment_id = var.compartment_ocid
  }
  is_enabled         = true
  retention_duration = 30
}