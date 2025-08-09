# Cloudflare Zero Trust Application

Opinionated Zero Trust Application module.

It allows to easily configure application access with reasonable default settings.

## Example Usage

The minimal configuraiton required to configure Zero Trust Application:

```
module "my_app_cloudflare_zero_trust_application" {
    source = "./modules/cloudflare/zero-trust/application"

    name   = "my_app"
    domain = "my_app.my_domain.com"
    type   = "self_hosted"
}
```
