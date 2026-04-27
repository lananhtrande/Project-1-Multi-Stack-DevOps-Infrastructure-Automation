variable "key_pair_name" {
  description = "The name of the AWS key pair to use for SSH access"
  type        = string
  default     = "lan-useast1-dvft-mar26"
}

variable "student_name" {
  type = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}