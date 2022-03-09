# general
variable "region" {
  type = string
}
variable "compartment_ocid" {
  type = string
}
variable "color" {
  type = string
}
# load blaancer
variable "load_balancer_backendset_name" {
  type = string
}
variable "load_balancer_id" {
  type = string
}