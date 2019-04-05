data "template_file" "users" {
  template = "${file("${path.module}/assets/users.cfg")}"

  vars {
    users = "${jsonencode(var.users)}"
  }
}

resource "local_file" "users" {
  content  = "${data.template_file.users.rendered}"
  filename = "${path.root}/.configs/${var.name}.cfg"
}

module "vm" {
  source            = "armorfret/wireguard-base/linode"
  version           = "0.0.8"
  name              = "${var.name}"
  ssh_keys          = ["${var.ssh_keys}"]
  ssh_users         = ["${var.ssh_users}"]
  region            = "${var.region}"
  type              = "${var.type}"
  source_image_id   = "${var.image_id}"
  ansible_repo_path = "${var.ansible_repo_path}"
}

resource "null_resource" "configuration" {
  triggers = {
    linode_id  = "${module.vm.linode_id}"
    ip_address = "${module.vm.ip_address}"
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${module.vm.ip_address}"
  }

  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "${var.ansible_repo_path}/main.yml"
        tags      = ["users"]
      }
    }

    defaults {
      extra_vars = {
        ansible_python_interpreter = "/usr/bin/python3"
        wireguard_config_path      = "/opt/wireguard"
        user_config_file           = "${local_file.users.filename}"
      }
    }
  }

  provisioner "local-exec" {
    command     = "${path.module}/assets/download.rb"
    working_dir = "${path.root}"

    environment = {
      VPN_IP_ADDRESS = "${module.vm.ip_address}"
      VPN_NAME       = "${var.name}"
      VPN_REGION     = "${var.region}"
    }
  }
}
