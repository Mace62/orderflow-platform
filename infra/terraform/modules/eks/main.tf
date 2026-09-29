## IAM Role for EKS Cluster
data "aws_iam_policy_document" "eks_cluster_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_policy.json
  tags = {
    Name = "${var.project}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

## EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn


  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = contains(["public", "both"], var.api_access)
    endpoint_private_access = contains(["private", "both"], var.api_access)
    public_access_cidrs     = var.public_access_cidrs
  }

  lifecycle {
    precondition {
      condition     = var.bootstrap_cluster_creator_admin_permissions || length(var.admin_principal_arns) > 0
      error_message = "Either bootstrap_cluster_creator_admin_permissions must be true, or at least one admin_principal_arn must be provided"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]

  tags = {
    Name = var.cluster_name
  }
}