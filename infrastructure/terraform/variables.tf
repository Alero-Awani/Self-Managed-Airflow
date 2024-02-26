variable "aws_profile" {
  type        = string
  description = "AWS config profile to use"
  default     = "default"
}

variable "aws_region" {
  type        = string
  description = "AWs region to deploy"
  default     = "us-east-1"
}

#network
variable "azs" {
  type        = list(any)
  description = "List of the availabilty zones to create subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnets" {
  type        = list(any)
  description = "List of private subnets CIDR"
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "public_subnets" {
  type        = list(any)
  description = "List of public subnets CIDR"
  default     = ["192.168.10.0/24", "192.168.11.0/24"]
}


variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "eks-cluster"
}

variable "iac_environment_tag" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}