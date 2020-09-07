resource "linode_instance" "vpn" {
  label = "${var.name}-wg"

  region = var.region
  type   = var.type

  disk {
    label = "root"
    size  = 10240

    image          = var.image_id
    stackscript_id = var.stackscript_id

    stackscript_data = {
      "users" = join(",", var.users)
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

