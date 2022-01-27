variable "compartment_ocid" {
    type = string
}

# naming
variable "color" {
    type = string
}

# parents
variable "subnet_id" {
    type =string
}

# application and function
variable "application_display_name" {
    type =string
}
variable "function_display_name" {
    type =string
}
variable "function_image" {
    type =string
}
variable "function_memory" {
    type =string
}

# gateway and deployment
variable "gateway_display_name" {
    type =string
}
variable "deployment_path_prefix" {
    type =string
}
variable "deployment_display_name" {
    type =string
}
variable "deployment_http_methods_api_retriever" {
    type =list(string)
}
variable "deployment_route_path_api_retriever" {
    type =string
}
variable "deployment_http_methods_frontend" {
    type =list(string)
}
variable "deployment_route_path_frontend" {
    type =string
}

# dns zone and records
variable "dns_zone_name" {
    type =string
}
variable "dns_zone_parent" {
    type =string
}