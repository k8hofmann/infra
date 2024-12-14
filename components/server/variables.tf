variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token for authorization"
  sensitive   = true
}

variable "ssh_key_name" {
  type        = string
  description = "Local ssh key name"
  sensitive   = true
}

variable "ssh_key_file" {
  type        = string
  description = "Local ssh key file location"
  sensitive   = true
}