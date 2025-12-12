output "application_name" {
  value       = argocd_application.app.metadata[0].name
  description = "Name of the ArgoCD application"
}

output "application_namespace" {
  value       = argocd_application.app.metadata[0].namespace
  description = "Namespace of the ArgoCD application"
}

output "application_id" {
  value       = argocd_application.app.id
  description = "ID of the ArgoCD application"
}

output "project_name" {
  value       = argocd_application.app.spec[0].project
  description = "Project name associated with the application"
}

# output "destination_server" {
#   value       = argocd_application.app.spec[0].destination[0].server
#   description = "Destination server for the application"
# }

# output "destination_namespace" {
#   value       = argocd_application.app.spec[0].destination[0].namespace
#   description = "Destination namespace for the application"
# }