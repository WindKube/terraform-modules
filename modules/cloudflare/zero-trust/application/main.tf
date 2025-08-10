resource "cloudflare_zero_trust_access_application" "this" {
  name   = var.name
  domain = var.domain
  type   = var.type

  account_id = var.account_id

  allowed_idps              = var.auth != null ? var.auth.allowed_idps : []
  auto_redirect_to_identity = var.auth != null ? var.auth.auto_redirect_to_identity : true

  logo_url             = var.app_launcher.logo_url
  app_launcher_visible = var.app_launcher.visible

  options_preflight_bypass    = var.settings.options_preflight_bypass
  path_cookie_attribute       = var.settings.path_cookie_attribute
  allow_authenticate_via_warp = var.settings.allow_authenticate_via_warp
  http_only_cookie_attribute  = var.settings.http_only_cookie_attribute
  enable_binding_cookie       = var.settings.enable_binding_cookie
  allow_iframe                = var.settings.allow_iframe
  same_site_cookie_attribute  = var.settings.same_site_cookie_attribute
  session_duration            = var.settings.session_duration

  policies = [for idx, policy_id in var.policies : {
    id         = policy_id
    precedence = idx
  }]

  tags = var.tags
}






