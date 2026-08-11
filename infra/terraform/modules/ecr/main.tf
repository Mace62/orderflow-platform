locals {
  repositories = toset(var.services)
}

resource "aws_ecr_repository" "this" {
  for_each = local.repositories

  name                 = "${var.project}/${each.value}"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  tags = merge(var.tags, {
    Name    = "${var.project}/${each.value}"
    Service = each.value
    Project = var.project
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.lifecycle_keep_count > 0 ? local.repositories : toset([])

  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }#,
      # {
      #   rulePriority = 2
      #   description  = "Keep only the last ${var.lifecycle_keep_count} tagged images"
      #   selection = {
      #     tagStatus   = "any"
      #     countType   = "imageCountMoreThan"
      #     countNumber = var.lifecycle_keep_count
      #   }
      #   action = {
      #     type = "expire"
      #   }
      # }
    ]
  })
}
