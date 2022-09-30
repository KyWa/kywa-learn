resource "digitalocean_container_registry" "container_reg" {
  name                   = "kywa"
  subscription_tier_slug = "starter"
}
