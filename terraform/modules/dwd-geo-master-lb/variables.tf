# general
variable "compartment_ocid" {
  type = string
}

# naming
variable "name" {
  type = string
}

# parents
variable "subnet_id" {
  type = string
}

# dns zone and records
variable "dns_zone_name" {
  type = string
}
variable "dns_zone_parent" {
  type = string
}
variable "dns_initial_cname_pointer" {
  type = string
}