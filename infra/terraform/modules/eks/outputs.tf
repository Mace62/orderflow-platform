output "cluster_name" {
    description = "The name of the EKS cluster"
    value = aws_eks_cluster.this.name
}

output "cluster_role_arn" {
    description = "The ARN of the EKS cluster role"
    value = aws_iam_role.eks_cluster_role.arn
}