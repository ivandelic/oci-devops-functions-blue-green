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

variable "devops_notification_subscription_endpoint_email" {
  type = string
}

variable "devops_notification_subscription_endpoint_slack" {
  type = string
}
