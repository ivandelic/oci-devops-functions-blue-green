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

# load balancer
variable "apigateway_ip_blue" {
  type = string
}
variable "apigateway_port_blue" {
  type = number
}
variable "apigateway_ip_green" {
  type = string
}
variable "apigateway_port_green" {
  type = number
}

# dns zone and records
variable "dns_zone_name" {
  type = string
}
variable "dns_zone_parent" {
  type = string
}