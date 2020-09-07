variable "name" {
  type        = string
  description = "The human-readable name for the server. Used when naming the Linode (with a suffix of '-wg')"
}

variable "region" {
  type        = string
  default     = "us-central"
  description = "Region to place the Linode in"
}

variable "type" {
  type        = string
  default     = "g6-standard-2"
  description = "Plan type for the Linode"
}

variable "users" {
  type        = list(string)
  description = "List of user accounts to provision for VPN access"
}

variable "image_id" {
  type        = string
  default     = "linode/ubuntu18.04"
  description = "Source image to build on"
}

variable "stackscript_id" {
  type        = string
  description = "Stackscript ID for wireguard deployment"
}

