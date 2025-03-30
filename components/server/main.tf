terraform {
  required_providers {

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49"
    }

    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "2.1.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

resource "hcloud_ssh_key" "ssh_key" {
  name = var.ssh_key_name
  public_key = file(var.ssh_key_file_pub)
}

resource "hcloud_server" "wonderland_server" {
  name        = "wonderland"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "nbg1"
  // ssh_keys    = [hcloud_ssh_key.ssh_key.id]
  backups     = true

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.network_1.id
    ip         = "10.0.1.5"
    alias_ips  = [
      "10.0.1.6",
      "10.0.1.7"
    ]
  }

  depends_on = [
    hcloud_network_subnet.network_1_subnet_eu_central
  ]

  provisioner "file" {
    source      = "${path.module}/scripts/setup_wireguard.sh"
    destination = "/root/setup_wireguard.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup_wireguard.sh",
      "/root/setup_wireguard.sh"
    ]
  }
}

resource "hcloud_network" "network_1" {
  name     = "network-1"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network_1_subnet_eu_central" {
  type         = "cloud"
  network_id   = hcloud_network.network_1.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_rdns" "domain_rdns" {
  server_id  = hcloud_server.wonderland_server.id
  ip_address = hcloud_server.wonderland_server.ipv4_address
  dns_ptr    = var.domain_name
}

resource "hetznerdns_record" "wonderland_dns_ipv4" {
  zone_id    = var.dns_zone_id
  name       = "@"
  value      = hcloud_server.wonderland_server.ipv4_address
  type       = "A"
  ttl        = 7200
}

resource "hetznerdns_record" "wonderland_dns_ipv6" {
  zone_id    = var.dns_zone_id
  name       = "@" 
  value      = hcloud_server.wonderland_server.ipv6_address
  type       = "AAAA"
  ttl        = 7200
}

resource "hetznerdns_record" "www" {
  zone_id    = var.dns_zone_id
  name       = "www"
  value      = hcloud_server.wonderland_server.ipv4_address
  type       = "A"
  ttl        = 7200
}