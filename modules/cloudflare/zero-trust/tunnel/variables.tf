variable "name" {
  description = "The name of the Cloudflare Zero Trust Tunnel."
  type        = string
}

variable "account_id" {
  description = "The account ID for the Cloudflare Zero Trust Tunnel."
  type        = string
}

variable "config" {
  description = "The configuration for the Cloudflare Zero Trust Tunnel."
  type = object({
    rules = optional(map(object({
      hostname = string
      service  = string
      path     = optional(string, "")
    })))
  })
}

variable "records" {
  description = "The DNS records for the Cloudflare Zero Trust Tunnel."
  type = list(object({
    zone_id = string
    domain  = string
  }))
  default = []
}
