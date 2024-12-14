terraform {
  required_providers {

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.49"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "ssh_key" {
  name = var.ssh_key_name
  public_key = file(var.ssh_key_file)
}

resource "hcloud_server" "wonderland_server" {
  name        = "wonderland"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]
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
