variable "log_group_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "flow_log_kms_key_id" {
  type = string
  default = null
}