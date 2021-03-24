provider "equinix" {
  client_id     = var.equinix_client_id
  client_secret = var.equinix_client_secret
}

module "fortigate" {
  source               = "equinix/fortigate/equinix"
  version              = "1.0.0-beta"
  byol                 = true
  self_managed         = true
  license_file         = "/tmp/FGVM-pri.lic"
  name                 = "tf-fortigate"
  metro_code           = var.metro_code_primary
  platform             = "medium"
  software_package     = "VM04"
  term_length          = 1
  notifications        = ["test@test.com"]
  hostname             = "forti-pri"
  additional_bandwidth = 100
  interface_count      = 18
  acl_template_id      = equinix_network_acl_template.fortigate-pri.id
  ssh_key = {
    username = "john"
    key_name = equinix_network_ssh_key.john.name
  }
  secondary = {
    enabled              = true
    license_file         = "/tmp/FGVM-sec.lic"
    metro_code           = var.metro_code_secondary
    hostname             = "forti-sec"
    additional_bandwidth = 100
    acl_template_id      = equinix_network_acl_template.fortigate-sec.id
  }
}

resource "equinix_network_ssh_key" "john" {
  name       = "johnKent"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpXGdxljAyPp9vH97436U171cX2gRkfPnpL8ebrk7ZBeeIpdjtd8mYpXf6fOI0o91TQXZTYtjABzeRgg6/m9hsMOnTHjzWpFyuj/hiPuiie1WtT4NffSH1ALQFX//zouBLmdNiYFMLfEVPZleergAqsYOHGCiQuR6Qh5j0yc5Wx+LKxiRZyjsSqo+EB8V6xBXi2i5PDJXK+dYG8YU9vdNeQdB84HvTWcGEnLR5w7pgC74pBVwzs3oWLy+3jWS0TKKtflmryeFRufXq87gEkC1MOWX88uQgjyCsemuhPdN++2WS57gu7vcqCMwMDZa7dukRS3JANBtbs7qQhp9Nw2PB4q6tohqUnSDxNjCqcoGeMNg/0kHeZcoVuznsjOrIDt0HgUApflkbtw1DP7Epfc2MJ0anf5GizM8UjMYiXEvv2U/qu8Vb7d5bxAshXM5nh67NSrgst9YzSSodjUCnFQkniz6KLrTkX6c2y2gJ5c9tWhg5SPkAc8OqLrmIwf5jGoHGh6eUJy7AtMcwE3iUpbrLw8EEoZDoDXkzh+RbOtSNKXWV4EAXsIhjQusCOWWQnuAHCy9N4Td0Sntzu/xhCZ8xN0oO67Cqlsk98xSRLXeg21PuuhOYJw0DLF6L68zU2OO0RzqoNq/FjIsltSUJPAIfYKL0yEefeNWOXSrasI1ezw== john@hades"
}

resource "equinix_network_acl_template" "fortigate-pri" {
  name        = "tf-fortigate-pri"
  description = "Primary Fortigate ACL template"
  metro_code  = var.metro_code_primary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}

resource "equinix_network_acl_template" "fortigate-sec" {
  name        = "tf-fortigate-vm-sec"
  description = "Secondary Fortigate ACL template"
  metro_code  = var.metro_code_secondary
  inbound_rule {
    subnets  = ["193.39.0.0/16", "12.16.103.0/24"]
    protocol = "TCP"
    src_port = "any"
    dst_port = "22"
  }
}
