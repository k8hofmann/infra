resource "hcloud_firewall" "wireguard" {
  name = "wireguard"

  # SSH access
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # WireGuard access
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "wireguard" {
  firewall_id = hcloud_firewall.wireguard.id
  server_ids  = [hcloud_server.wonderland_server.id]
} 