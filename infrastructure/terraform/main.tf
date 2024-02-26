provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name            = "airflow-vpc"
  cidr            = "192.168.0.0/16"
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false


  enable_dns_hostnames = true
  enable_dns_support   = true

  # Add VPC/Subnet tags required by EKS 
  tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    iac_environment                                 = var.iac_environment_tag
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
    iac_environment                                 = var.iac_environment_tag

  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
    iac_environment                                 = var.iac_environment_tag
  }


}

