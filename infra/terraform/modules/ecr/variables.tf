variable "project" {
  description = "Project name used as the ECR repository name prefix (e.g. orderflow/api-gateway)"
  type        = string
}

variable "services" {
  description = "Service names that each get an ECR repository"
  type        = list(string)
}

variable "scan_on_push" {
  description = "Enable image scanning when images are pushed"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Allow terraform destroy even when images exist in the repository"
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "Tag mutability setting: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "encryption_type" {
  description = "ECR encryption type: AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN when encryption_type is KMS (optional)"
  type        = string
  default     = null
}

variable "lifecycle_keep_count" {
  description = "Number of tagged images to keep per repository (0 disables the lifecycle policy)"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Additional tags applied to all ECR repositories"
  type        = map(string)
  default     = {}
}
