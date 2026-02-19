module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "project-bedrock-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw         = true

  # TAGS FOR INTERNET-FACING LOAD BALANCER
  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/project-bedrock-cluster" = "owned"
    "Project"                                       = "Bedrock"
  }

  # TAGS FOR INTERNAL LOAD BALANCER & NODES
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/project-bedrock-cluster" = "owned"
    "Project"                                       = "Bedrock"
  }

  tags = {
    "Project" = "Bedrock"
  }
}