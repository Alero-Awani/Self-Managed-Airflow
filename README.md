# Self-Managed Apache Airflow on EKS with Terraform

## Self-Managed Apache Airflow

- Greater level of control of the configuration of Apache Airflow
- Need to run workflows that use more resources than AWS Managed services 
- Total cost of Ownership

### Prerequisites 

- Terraform 
- Helm 
- AWS CLI 
- Kubectl 
- AWS account with sufficient privileges 

### Resources 

The resources created include 

- EKS Cluster Control plane with public endpoint
- One managed node group - Node group made up of 2 instances spanning 2azs
- 

### References 
- https://blog.beachgeek.co.uk/self-managed-apache-airflow-using-doeks/

### eks-cluster.tf

```terraform
resource "kubernetes_service_account" "eksadmin" {
  metadata {
    name = "eks-admin"
    namespace = "kube-system"
  }
}
```

In setting up Apache Airflow on Amazon EKS, the "eks-admin" service account is often granted necessary RBAC (Role-Based Access Control) permissions to perform actions within the Kubernetes cluster.

Apache Airflow often requires specific permissions to create and manage Kubernetes pods, services, and other resources. By creating a dedicated service account and configuring appropriate RBAC rules, you can ensure that Airflow has the necessary permissions to interact with the Kubernetes cluster.

```tf
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
```

Putting it all together, this `kubernetes_cluster_role_binding` resource is binding the "eks-admin" ServiceAccount in the "kube-system" namespace to the "cluster-admin" ClusterRole. This essentially gives the "eks-admin" ServiceAccount broad administrative permissions over the entire Kubernetes cluster.
