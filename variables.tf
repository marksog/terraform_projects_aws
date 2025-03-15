variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "instance_tenancy" {
  description = "VPC Instance Tenancy"
  type        = string
  default     = "default"
}

variable "tag_overlay" {
  description = "Tags for resources"
  type        = map(string)
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "pubrt_cidrblock" {
  description = "Public Route Table CIDR block"
  type        = string
}

variable "privrt_cidrblock" {
  description = "Private Route Table CIDR block"
  type        = string
}