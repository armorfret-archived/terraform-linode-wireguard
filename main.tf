resource "linode_instance" "vpn" {
  label = "${var.name}-wg"

  region = var.region
  type   = var.type

  disk {
    label = "root"
    size  = 10240

    // TODO: remove this
    authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJ8nnGTRnVJR6Sz6lnYdRchw2Z4S9DFOKTHuJBnMYBS"]
    image           = var.image_id
    // TODO: make this optional
    stackscript_id = var.stackscript_id

    stackscript_data = {
      "users"        = join(",", var.users)
      "docker_image" = var.docker_image
    }
  }

  config {
    label  = "default"
    kernel = "linode/grub2"

    devices {
      sda {
        disk_label = "root"
      }
    }
  }
}

