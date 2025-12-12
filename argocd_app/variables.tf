variable "app_name" {
  type        = string
  description = "The name of the ArgoCD application."
}

variable "app_namespace" {
  type        = string
  description = "The namespace where the ArgoCD application resource should be created."
}

variable "namespace" {
  type        = string
  description = "The target namespace where the application should be deployed."
}

variable "destination_server" {
  description = "The Kubernetes API destination_server URL for ArgoCD applications."
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "project_name" {
  type        = string
  description = "The ArgoCD project name to associate with this application."
  default     = "core"
}

variable "sync_options" {
  type        = list(string)
  description = "A list of sync options for the application (e.g., [\"CreateNamespace=true\"])"
  default     = []
}

variable "value_sources" {
  description = "A map of value sources that can be referenced by applications."
  type = map(object({
    repo_url        = string
    target_revision = string
  }))
  default = {}
}

variable "manifest_app" {
  description = "Configuration for applications using plain Kubernetes manifests."
  type = object({
    source_repo     = string
    path            = string
    target_revision = string
  })
  default = null
}

variable "helm_app" {
  description = "Configuration for applications using Helm charts."
  type = object({
    helm_repo       = string
    chart           = string
    target_revision = optional(string, null)
    value_files     = optional(list(string), [])
    values          = optional(map(string), {})
    release_name    = optional(string)
  })
  default = null
}

variable "sync_policy" {
  description = <<-EOT
    The sync policy configuration for the ArgoCD application.
    
    The following nested properties are supported:
    - automated: Configuration for automated synchronization
      - prune: Whether to automatically prune resources when they are removed from git
      - self_heal: Whether to automatically sync when the live state differs from the target state
      - allow_empty: Whether to allow apps with no resources to be created
    - sync_options: A list of sync options for applications (e.g., ["CreateNamespace=true"])
    - retry: Configuration for retry behavior when sync fails
      - limit: The maximum number of sync attempts
      - backoff: Configuration for backoff timing between retries
        - duration: The initial duration to wait between retries
        - max_duration: The maximum duration to wait between retries
        - factor: The multiplier for the backoff duration between retries
  EOT
  type = object({
    automated = optional(object({
      prune       = optional(bool, false)
      self_heal   = optional(bool, false)
      allow_empty = optional(bool, false)
    }), {})
    sync_options = optional(list(string), [])
    retry = optional(object({
      limit = optional(string, "5")
      backoff = optional(object({
        duration     = optional(string, "30s")
        max_duration = optional(string, "2m")
        factor       = optional(string, "2")
      }), {})
    }), {})
  })
  default = {
    automated = {
      prune       = true
      self_heal   = true
      allow_empty = true
    }
    sync_options = ["CreateNamespace=true"]
    retry = {
      limit = "5"
      backoff = {
        duration     = "30s"
        max_duration = "2m"
        factor       = "2"
      }
    }
  }
}

variable "cascade" {
  type        = bool
  description = "Enable cascading deletion for the application."
  default     = true
}

variable "wait" {
  type        = bool
  description = "Wait for the application to be synced."
  default     = true
}