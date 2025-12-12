# ArgoCD Application Module

This module creates a single ArgoCD application resource in Kubernetes. It's based on the `argocd_application.apps` resource from the core module but simplified to create only one application at a time.

## Usage

```hcl
module "my_app" {
  source = "../modules/argocd_app"
  
  app_name      = "my-application"
  app_namespace = "argocd"
  namespace     = "my-app-namespace"
  
  # For Helm applications
  helm_app = {
    helm_repo       = "https://charts.example.com"
    chart           = "my-chart"
    target_revision = "1.0.0"
    value_files     = ["values.yaml"]
    values = {
      key1 = "value1"
      key2 = "value2"
    }
  }
  
  # OR for manifest applications
  manifest_app = {
    source_repo     = "https://github.com/example/my-repo"
    path            = "manifests"
    target_revision = "main"
  }
  
  # Sync policy
  sync_policy = {
    automated = {
      prune       = true
      self_heal   = true
      allow_empty = false
    }
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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| app_name | The name of the ArgoCD application. | `string` | n/a | yes |
| app_namespace | The namespace where the ArgoCD application resource should be created. | `string` | n/a | yes |
| namespace | The target namespace where the application should be deployed. | `string` | n/a | yes |
| destination_server | The Kubernetes API destination_server URL for ArgoCD applications. | `string` | `"https://kubernetes.default.svc"` | no |
| project_name | The ArgoCD project name to associate with this application. | `string` | `"core"` | no |
| sync_options | A list of sync options for the application (e.g., `["CreateNamespace=true"]`) | `list(string)` | `[]` | no |
| value_sources | A map of value sources that can be referenced by applications. | `map(object({...}))` | `{}` | no |
| manifest_app | Configuration for applications using plain Kubernetes manifests. | `object({...})` | `null` | no |
| helm_app | Configuration for applications using Helm charts. | `object({...})` | `null` | no |
| sync_policy | The sync policy configuration for the ArgoCD application. | `object({...})` | `{}` | no |
| cascade | Enable cascading deletion for the application. | `bool` | `true` | no |
| wait | Wait for the application to be synced. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| application_name | Name of the ArgoCD application |
| application_namespace | Namespace of the ArgoCD application |
| application_id | ID of the ArgoCD application |
| project_name | Project name associated with the application |
| destination_server | Destination server for the application |
| destination_namespace | Destination namespace for the application |