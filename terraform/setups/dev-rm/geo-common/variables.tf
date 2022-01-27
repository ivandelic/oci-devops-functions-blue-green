# general
variable "region" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
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
