# general
variable "region" {
    type = string
}
variable "tenancy_ocid" {
    type = string
}
variable "compartment_ocid" {
    type = string
}

# user identity
variable "user_ocid" {
    type = string
}
variable "fingerprint" {
    type = string
}
variable "private_key_path" {
    type = string
}

# general

variable "dns_initial_cname_pointer" {
  type = string
}

variable "lb_subnet_id" {
    type = string
}