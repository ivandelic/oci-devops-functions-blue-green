resource "oci_artifacts_repository" "artifacts_repository" {
    compartment_id = var.compartment_ocid
    is_immutable = false
    display_name = var.artifact_repository_name
    repository_type = "generic"
}

resource "oci_artifacts_container_repository" "artifacts_container_repository" {
    compartment_id = var.compartment_ocid
    display_name = var.arifact_true_fn_image_name
    is_immutable = false
    is_public = false
}