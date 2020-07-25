terraform {
  required_version = "0.13.0"
}

variable "aws_access_key_id" {
  description = "AWS access key ID"
  type = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type = string
}