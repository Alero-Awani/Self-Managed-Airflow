module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name = var.eks_cluster_name
  vpc_id       = local.vpc.vpc_id

  subnet_ids = [local.vpc.private_subnets[0], local.vpc.public_subnets[1]]

  cluster_endpoint_public_access = true


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    eks_node_group = {
      name         = "node-group-1"
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}

resource "kubernetes_service_account" "eksadmin" {
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "eksadmin" {
  metadata {
    name = "eks-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_secret" "airflow_db_credentials" {
  metadata {
    name      = "airflow-db-auth"
    namespace = kubernetes_namespace.airflow.metadata[0].name
  }
  data = {
    "postgresql-password" = "${var.airflowdb_password}"
  }
}

# resource "aws_security_group" "nodegroup_management" {
#   name_prefix = "nodegroup_management"
#   vpc_id      = local.vpc.vpc_id
#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#     cidr_blocks = [
#       "10.0.0.0/8",
#       "172.16.0.0/12",
#       "192.168.0.0/16",
#     ]
#   }
# }