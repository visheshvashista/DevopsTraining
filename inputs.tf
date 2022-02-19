variable "aws_region" {
  type = string
  description = "AWS region where resources will be deployed"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
  sensitive = true
}