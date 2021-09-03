locals {
  actions_runner_controller_enabled = module.this.enabled && contains(var.apps_to_install, "actions_runner_controller")
  actions_runner_controller_helm_default_params = {
    repository      = "https://actions-runner-controller.github.io/actions-runner-controller"
    chart           = "actions-runner-controller"
    version         = "0.12.7"
    override_values = ""
  }
  actions_runner_controller_helm_default_values = {
    "fullnameOverride"       = "${local.actions_runner_controller["name"]}"
    "dockerRegistryMirror"   = "mirror.gcr.io"
    "githubAPICacheDuration" = "60s"
    "metrics" = {
      "serviceMonitor" = "enabled"
    }
    "resources" = {
      "limits" = {
        "cpu"    = "100m"
        "memory" = "128Mi"
      }
      "requests" = {
        "cpu"    = "100m"
        "memory" = "128Mi"
      }
    }
    "syncPeriod" = "30s"
  }
  actions_runner_controller = defaults(var.actions_runner_controller, merge(local.helm_default_params, local.actions_runner_controller_helm_default_params))
}

data "utils_deep_merge_yaml" "actions_runner_controller" {
  count = local.actions_runner_controller_enabled ? 1 : 0

  input = [
    yamlencode(local.actions_runner_controller_helm_default_values),
    local.actions_runner_controller["override_values"]
  ]
}

resource "helm_release" "actions_runner_controller" {
  count = local.actions_runner_controller_enabled ? 1 : 0

  name              = local.actions_runner_controller["name"]
  repository        = local.actions_runner_controller["repository"]
  chart             = local.actions_runner_controller["chart"]
  version           = local.actions_runner_controller["version"]
  namespace         = local.actions_runner_controller["namespace"]
  max_history       = local.actions_runner_controller["max_history"]
  create_namespace  = local.actions_runner_controller["create_namespace"]
  dependency_update = local.actions_runner_controller["dependency_update"]
  reuse_values      = local.actions_runner_controller["reuse_values"]
  wait              = local.actions_runner_controller["wait"]
  timeout           = local.actions_runner_controller["timeout"]
  values            = [one(data.utils_deep_merge_yaml.actions_runner_controller[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.kube_prometheus_stack,
    helm_release.ingress_nginx,
  ]
}
