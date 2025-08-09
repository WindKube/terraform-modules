variable "account_id" {
  description = <<EOT
        The Cloudflare account ID to use for the resources.
        - Must be the UUID of your Cloudflare account.
    EOT
  type        = string
}

variable "app_launcher" {
  description = <<EOT
        The configuration for the app launcher.
        - visible  (bool): Whether the application is shown in the Cloudflare Access App Launcher.
        - logo_url (string): Public URL to an image used as the application icon in the App Launcher.
    EOT
  type = object({
    visible  = bool
    logo_url = string
  })
  default = null
}

variable "policies" {
  description = <<EOT
        A list of policies to apply to the application. Provide the policy IDs.
        - Order defines precedence (first has highest precedence, index 0).
        - Each item is a string ID of an existing Cloudflare Access policy.
    EOT
  type        = list(string)
  default     = []
}

variable "name" {
  description = <<EOT
        The name of the application.
        - Display name shown in the dashboard and App Launcher (if enabled).
    EOT
  type        = string
}

variable "domain" {
  description = <<EOT
        The domain (hostname + optional path) for the application.
        - Format: "<hostname>[/<path>]". Example: "test.example.com/admin".
        - Path scoping restricts Access to the specified path prefix.
    EOT
  type        = string
}

variable "auth" {
  description = <<EOT
        Authentication configuration for the application. If not configured, all IDPs will be allowed.
        - allowed_idps (list(string)): List of Identity Provider (IdP) IDs allowed to authenticate.
        - auto_redirect_to_identity (bool, default: true): If true and exactly one IDP is allowed, users are redirected to that IDP automatically.
            Note: If auto_redirect_to_identity is true, allowed_idps must contain exactly one IDP.
    EOT
  type = object({
    allowed_idps              = list(string)
    auto_redirect_to_identity = optional(bool, true)
  })
  default = null

  validation {
    condition     = var.auth.auto_redirect_to_identity ? length(var.auth.allowed_idps) == 1 : true
    error_message = "If auto_redirect_to_identity is true, allowed_idps must contain exactly one IDP."
  }
}

variable "settings" {
  description = <<EOT
                Various settings for the application with sensible defaults:
                - options_preflight_bypass - Option to skip the authorization interstitial when using the CLI or API
                - http_only_cookie_attribute - Toggle to use the HttpOnly cookie attribute, which prevents client-side scripts from accessing the cookie
                - enable_binding_cookie - Toggle to enable the binding cookie, which increases security against compromised authorization tokens and CSRF attacks
                - allow_authenticate_via_warp - Toggle to allow authentication via WARP. When disabled, users will only be able to login via the web UI
                - allow_iframe - Toggle to allow the application to be embedded in an iframe
                - path_cookie_attribute - Toggle to use the Path cookie attribute, which restricts the cookie to a specific path
                - same_site_cookie_attribute - Sets the SameSite cookie setting, which provides increased security against CSRF attacks.
                - session_duration - Access session lifetime (e.g., "24h", "30m"). Users must re-authenticate after expiry.
        EOT
  type = object({
    options_preflight_bypass    = optional(bool, true)
    http_only_cookie_attribute  = optional(bool, true)
    enable_binding_cookie       = optional(bool, true)
    allow_authenticate_via_warp = optional(bool, true)
    allow_iframe                = optional(bool, false)
    path_cookie_attribute       = optional(bool, true)
    same_site_cookie_attribute  = optional(string, "strict")
    session_duration            = optional(string, "24h")
  })
  default = {}
}

variable "type" {
  description = <<EOT
        The type of the application.
        - Allowed values:
            self_hosted, saas, ssh, vnc, app_launcher, warp, biso, bookmark, dash_sso, infrastructure, rdp.
    EOT
  type        = string

  validation {
    condition     = contains(["self_hosted", "saas", "ssh", "vnc", "app_launcher", "warp", "biso", "bookmark", "dash_sso", "infrastructure", "rdp"], var.type)
    error_message = "Invalid application type. Must be one of: self_hosted, saas, ssh, vnc, app_launcher, warp, biso, bookmark, dash_sso, infrastructure, rdp."
  }
}

variable "tags" {
  description = <<EOT
        A list of tags to apply to the application.
        - Free-form strings for organization, reporting, or policy grouping.
    EOT
  type        = list(string)
  default     = []
}
