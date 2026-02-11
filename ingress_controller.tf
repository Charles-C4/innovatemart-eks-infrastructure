# 1. OIDC Provider (Keep this active - it is an AWS resource)
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# 2. Kubernetes Service Account (Links IAM to the Pod)
# Commented out to bypass Kubernetes API authentication in GitHub Actions
resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lb_controller_role.iam_role_arn
    }
  }
}

# 3. Helm Release (The 'Brain' of the ALB)
resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [
    yamlencode({
      clusterName = aws_eks_cluster.main.name
      serviceAccount = {
        create = false
        name   = kubernetes_service_account.lb_controller.metadata[0].name
      }
      region = "us-east-1"
      vpcId  = module.vpc.vpc_id
    })
  ]
}
