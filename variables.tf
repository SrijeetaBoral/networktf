variable "region" {
  description = "AWS region"
  type        = string
}
variable "project_id" {
  description = "Project ID used in names and tags"
  type        = string
}
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}
variable "public_instance_id" {
  description = "Public EC2 instance ID"
  type        = string
}
variable "private_instance_id" {
  description = "Private EC2 instance ID"
  type        = string
}
variable "allowed_ip_range" {
  description = "CIDR ranges allowed to access the infrastructure"
  type        = list(string)
}