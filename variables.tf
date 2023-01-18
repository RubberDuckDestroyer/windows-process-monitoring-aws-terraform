variable "environment" {
  description = "AWS environment"
  default     = "dev"
  type        = string

}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"

}

variable ami_id {
    description = "AMI ID Windows Server 2019 with MSSQL 2017"
    type = string
    default = "ami-0e6a65b71431dac66"
}

variable namespace {
    description = "namespace for cloudwatch monitoring"
    default = "custom_proc_monitor"
    type = string
}

variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string

}

variable "subnet_id" {
  description = "Public Subnet ID for EC2 Instance"
  type        = string

}

variable "whitelist_cidr_ip" {
  description = "IP Address for RDP to Windows Server"
  type = string
}

variable "email_endpoint" {
  description = "Email for SNS topic"
  type = string
}