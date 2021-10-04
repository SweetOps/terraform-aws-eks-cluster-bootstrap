locals {
  github_actions_runners_enabled = module.this.enabled && contains(var.apps_to_install, "github_actions_runners")
  github_actions_runners         = defaults(var.github_actions_runners, merge(local.helm_default_params, local.github_actions_runners_helm_default_params))

  github_actions_runners_helm_default_params = {
    repository      = "https://sweetops.github.io/helm-charts"
    chart           = "github-actions-runners"
    version         = "0.1.0"
    override_values = ""
  }

  github_actions_runners_helm_default_values = {
    "fullnameOverride" = "${local.github_actions_runners["name"]}"
  }

}

data "utils_deep_merge_yaml" "github_actions_runners" {
  count = local.github_actions_runners_enabled ? 1 : 0

  input = [
    yamlencode(local.github_actions_runners_helm_default_values),
    local.github_actions_runners["override_values"]
  ]
}

resource "helm_release" "github_actions_runners" {
  count = local.github_actions_runners_enabled ? 1 : 0

  name              = local.github_actions_runners["name"]
  repository        = local.github_actions_runners["repository"]
  chart             = local.github_actions_runners["chart"]
  version           = local.github_actions_runners["version"]
  namespace         = local.github_actions_runners["namespace"]
  max_history       = local.github_actions_runners["max_history"]
  create_namespace  = local.github_actions_runners["create_namespace"]
  dependency_update = local.github_actions_runners["dependency_update"]
  reuse_values      = local.github_actions_runners["reuse_values"]
  wait              = local.github_actions_runners["wait"]
  timeout           = local.github_actions_runners["timeout"]
  values            = [one(data.utils_deep_merge_yaml.github_actions_runners[*].output)]

  depends_on = [
    helm_release.actions_runner_controller
  ]
}
