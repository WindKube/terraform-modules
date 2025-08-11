resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id    = var.account_id
  name          = var.name
  config_src    = "cloudflare"
  tunnel_secret = random_id.this.b64_std
}

resource "random_id" "this" {
  byte_length = 64
}

resource "cloudflare_dns_record" "this" {
  for_each = var.records
  zone_id  = each.value.zone_id
  name     = each.value.domain
  type     = "CNAME"
  value    = cloudflare_zero_trust_tunnel_cloudflared.this.cname
  proxied  = true
}

resource "cloudflare_tunnel_config" "this" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id

  config {
    origin_request {
      no_tls_verify = true
    }
    dynamic "ingress_rule" {
      for_each = var.config.rules
      content {
        hostname = ingress_rule.value.hostname
        service  = ingress_rule.value.service
        path     = ingress_rule.value.path
      }
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}
