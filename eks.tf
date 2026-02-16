# 1. The EKS Cluster (The Brain)
resource "aws_eks_cluster" "main" {
  name     = "project-bedrock-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    # Combines private and public subnets for the control plane
    subnet_ids             = concat(module.vpc.private_subnets, module.vpc.public_subnets)
    endpoint_public_access = true
  }

  # Ensure the IAM Role Policy is attached before the cluster is created
  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# 2. The Managed Node Group (The Body/Compute)
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "bedrock-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  # Nodes must live in PRIVATE subnets for security
  subnet_ids = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  # Ensures the IAM policies for nodes are attached before they try to join
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}