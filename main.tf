resource "linode_instance" "vpn" {
  label = "${var.name}-wg"

  region = "${var.region}"
  type   = "${var.type}"

  disk {
    label = "root"
    size  = 10240

    // TODO: remove this
    authorized_keys = ["${var.ssh_keys}"]
    image           = "${var.image_id}"
    stackscript_id  = "${linode_stackscript.this.id}"

    stackscript_data = {
      "users"       = "${var.users}"
      "deploy_repo" = "${var.deploy_repo}"
    }
  }

  config {
    label  = "default"
    kernel = "linode/grub2"

    devices {
      sda = {
        disk_label = "root"
      }
    }
  }
}

resource "linode_stackscript" "this" {
  label       = "${var.name}-wg"
  description = "Deploy wireguard"
  script      = "${file("${path.module}/assets/stackscript.sh")}"
  images      = ["${var.image_id}"]
}
