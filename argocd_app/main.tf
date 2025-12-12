resource "argocd_application" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
  }
  cascade = var.cascade
  wait    = var.wait
  spec {
    destination {
      server    = var.destination_server
      namespace = var.namespace
    }
    project = var.project_name

    # Value Sources
    dynamic "source" {
      for_each = var.value_sources
      content {
        repo_url        = source.value.repo_url
        target_revision = source.value.target_revision
        ref             = source.key
      }
    }

    # Helm Charts
    dynamic "source" {
      for_each = var.helm_app != null ? [var.helm_app] : []
      content {
        repo_url        = source.value.helm_repo
        chart           = source.value.chart
        target_revision = source.value.target_revision
        helm {
          release_name = can(coalesce(source.value.release_name, null)) ? source.value.release_name : var.app_name
          value_files  = source.value.value_files
          values       = yamlencode(source.value.values)
        }
      }
    }

    # Manifest App
    dynamic "source" {
      for_each = var.manifest_app != null ? [var.manifest_app] : []
      content {
        repo_url        = source.value.source_repo
        path            = source.value.path
        target_revision = source.value.target_revision
      }
    }

    sync_policy {
      automated {
        prune       = var.sync_policy.automated.prune
        self_heal   = var.sync_policy.automated.self_heal
        allow_empty = var.sync_policy.automated.allow_empty
      }
      sync_options = coalescelist(var.sync_options, var.sync_policy.sync_options)
      retry {
        limit = var.sync_policy.retry.limit
        backoff {
          duration     = var.sync_policy.retry.backoff.duration
          max_duration = var.sync_policy.retry.backoff.max_duration
          factor       = var.sync_policy.retry.backoff.factor
        }
      }
    }
  }
}