resource "oci_functions_application" "application" {
    compartment_id = var.compartment_ocid
    display_name = join("-", [var.application_display_name, var.color])
    subnet_ids = [var.subnet_id]
}

resource "oci_functions_function" "function" {
  application_id = oci_functions_application.application.id
  display_name   = var.function_display_name
  image          = var.function_image
  memory_in_mbs  = var.function_memory
}