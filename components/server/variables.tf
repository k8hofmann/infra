variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token for authorization"
  sensitive   = true
}

variable "hetznerdns_token" {
  type        = string
  description = "Hetzner DNS API token for authorization"
  sensitive   = true
}

variable "ssh_key_name" {
  type        = string
  description = "Local ssh key name"
  sensitive   = true
}

variable "ssh_key_file_pub" {
  type        = string
  description = "Local ssh public key file location"
  sensitive   = true
}

variable "dns_zone_id" {
  type        = string
  description = "Dns zone id"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "Domain name"
  sensitive   = true
}