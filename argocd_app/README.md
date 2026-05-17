# ArgoCD Application Module

This module creates a single ArgoCD application resource in Kubernetes. It's based on the `argocd_application.apps` resource from the core module but simplified to create only one application at a time.

## Usage

```hcl
module "my_app" {
  source = "git::https://github.com/rNimbus-com/argocd-tofu-modules.git//argocd_app?ref=v1"
  
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
  
  # Directory / Kustomize source (can be combined with helm_app)
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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >=7.11 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | >=7.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [argocd_application.app](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/application) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the ArgoCD application. | `string` | n/a | yes |
| <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace) | The namespace where the ArgoCD application resource should be created. | `string` | n/a | yes |
| <a name="input_cascade"></a> [cascade](#input\_cascade) | Enable cascading deletion for the application. | `bool` | `true` | no |
| <a name="input_destination_server"></a> [destination\_server](#input\_destination\_server) | The Kubernetes API destination\_server URL for ArgoCD applications. | `string` | `"https://kubernetes.default.svc"` | no |
| <a name="input_helm_app"></a> [helm\_app](#input\_helm\_app) | Configuration for applications using Helm charts. | <pre>object({<br/>    helm_repo                  = string<br/>    chart                      = string<br/>    target_revision            = optional(string, null)<br/>    value_files                = optional(list(string), [])<br/>    values                     = optional(map(string), {})<br/>    release_name               = optional(string)<br/>    ignore_missing_value_files = optional(bool, false)<br/>    pass_credentials           = optional(bool, false)<br/>    skip_crds                  = optional(bool, false)<br/>    skip_schema_validation     = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_ignore_differences"></a> [ignore\_differences](#input\_ignore\_differences) | Configurations for ignoring differences during sync operations.<br/><br/>The following nested properties are supported:<br/>- group: The Kubernetes resource Group to match for.<br/>- jq\_path\_expressions: List of JQ path expression strings targeting the field(s) to ignore.<br/>- json\_pointers: List of JSONPaths strings targeting the field(s) to ignore.<br/>- kind: The Kubernetes resource Kind to match for.<br/>- name: The Kubernetes resource Name to match for.<br/>- namespace: The Kubernetes resource Namespace to match for. | <pre>list(object({<br/>    group               = optional(string, null)<br/>    jq_path_expressions = optional(set(string), [])<br/>    json_pointers       = optional(set(string), [])<br/>    kind                = optional(string, null)<br/>    name                = optional(string, null)<br/>    namespace           = optional(string, null)<br/>  }))</pre> | `null` | no |
| <a name="input_manifest_app"></a> [manifest\_app](#input\_manifest\_app) | Configuration for applications using directory or kustomize sources. ArgoCD auto-detects the type based on directory contents (kustomization.yaml = Kustomize, otherwise Directory). | <pre>object({<br/>    source_repo     = string<br/>    path            = string<br/>    target_revision = string<br/>  })</pre> | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The target namespace where the application should be deployed. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The ArgoCD project name to associate with this application. | `string` | `"core"` | no |
| <a name="input_sync_options"></a> [sync\_options](#input\_sync\_options) | A list of sync options for the application (e.g., ["CreateNamespace=true"]) | `list(string)` | `[]` | no |
| <a name="input_sync_policy"></a> [sync\_policy](#input\_sync\_policy) | The sync policy configuration for the ArgoCD application.<br/><br/>The following nested properties are supported:<br/>- automated: Configuration for automated synchronization<br/>  - prune: Whether to automatically prune resources when they are removed from git<br/>  - self\_heal: Whether to automatically sync when the live state differs from the target state<br/>  - allow\_empty: Whether to allow apps with no resources to be created<br/>- sync\_options: A list of sync options for applications (e.g., ["CreateNamespace=true"])<br/>- retry: Configuration for retry behavior when sync fails<br/>  - limit: The maximum number of sync attempts<br/>  - backoff: Configuration for backoff timing between retries<br/>    - duration: The initial duration to wait between retries<br/>    - max\_duration: The maximum duration to wait between retries<br/>    - factor: The multiplier for the backoff duration between retries | <pre>object({<br/>    automated = optional(object({<br/>      prune       = optional(bool, false)<br/>      self_heal   = optional(bool, false)<br/>      allow_empty = optional(bool, false)<br/>    }), {})<br/>    sync_options = optional(list(string), [])<br/>    retry = optional(object({<br/>      limit = optional(string, "5")<br/>      backoff = optional(object({<br/>        duration     = optional(string, "30s")<br/>        max_duration = optional(string, "2m")<br/>        factor       = optional(string, "2")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | <pre>{<br/>  "automated": {<br/>    "allow_empty": true,<br/>    "prune": true,<br/>    "self_heal": true<br/>  },<br/>  "retry": {<br/>    "backoff": {<br/>      "duration": "30s",<br/>      "factor": "2",<br/>      "max_duration": "2m"<br/>    },<br/>    "limit": "5"<br/>  },<br/>  "sync_options": [<br/>    "CreateNamespace=true"<br/>  ]<br/>}</pre> | no |
| <a name="input_value_sources"></a> [value\_sources](#input\_value\_sources) | A map of value sources that can be referenced by applications. | <pre>map(object({<br/>    repo_url        = string<br/>    target_revision = string<br/>  }))</pre> | `{}` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | Wait for the application to be synced. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | ID of the ArgoCD application |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | Name of the ArgoCD application |
| <a name="output_application_namespace"></a> [application\_namespace](#output\_application\_namespace) | Namespace of the ArgoCD application |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project name associated with the application |
<!-- END_TF_DOCS -->