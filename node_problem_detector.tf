locals {
  node_problem_detector_enabled = module.this.enabled && contains(var.apps_to_install, "node_problem_detector")
  node_problem_detector_helm_default_params = {
    repository      = "https://charts.deliveryhero.io/"
    chart           = "node-problem-detector"
    version         = "2.0.5"
    override_values = ""
  }
  node_problem_detector_helm_default_values = {
    "fullnameOverride" = "${local.node_problem_detector["name"]}"
    "metrics" = {
      "enabled" = true
      "serviceMonitor" = {
        "enabled" = true
      }
    }
    "resources" = {
      "limits" = {
        "cpu"    = "100m"
        "memory" = "100Mi"
      }
      "requests" = {
        "cpu"    = "50m"
        "memory" = "50Mi"
      }
    }
    "settings" = {
      "log_monitors" = [
        "/config/kernel-monitor.json",
        "/config/docker-monitor.json",
        "/config/kernel-monitor-filelog.json",
        "/config/systemd-monitor-counter.json",
      ]
    }
  }
  node_problem_detector = defaults(var.node_problem_detector, merge(local.helm_default_params, local.node_problem_detector_helm_default_params))
}

data "utils_deep_merge_yaml" "node_problem_detector" {
  count = local.node_problem_detector_enabled ? 1 : 0

  input = [
    yamlencode(local.node_problem_detector_helm_default_values),
    local.node_problem_detector["override_values"]
  ]
}

resource "helm_release" "node_problem_detector" {
  count = local.node_problem_detector_enabled ? 1 : 0

  name              = local.node_problem_detector["name"]
  repository        = local.node_problem_detector["repository"]
  chart             = local.node_problem_detector["chart"]
  version           = local.node_problem_detector["version"]
  namespace         = local.node_problem_detector["namespace"]
  max_history       = local.node_problem_detector["max_history"]
  create_namespace  = local.node_problem_detector["create_namespace"]
  dependency_update = local.node_problem_detector["dependency_update"]
  reuse_values      = local.node_problem_detector["reuse_values"]
  wait              = local.node_problem_detector["wait"]
  timeout           = local.node_problem_detector["timeout"]
  values            = [one(data.utils_deep_merge_yaml.node_problem_detector[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
  ]
}
