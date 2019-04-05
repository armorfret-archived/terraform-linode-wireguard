data "template_file" "config" {
  template = "${file("${path.module}/assets/config.cfg")}"

  vars {
    userlist   = "${jsonencode(var.users)}"
    ip_address = "${module.vm.ip_address}"
  }
}

module "vm" {
  source          = "armorfret/wireguard-base/linode"
  version         = "0.0.6"
  name            = "${var.name}"
  ssh_keys        = ["${var.ssh_keys}"]
  ssh_users       = ["${var.ssh_users}"]
  region          = "${var.region}"
  type            = "${var.type}"
  deploy_repo     = "${var.deploy_repo}"
  source_image_id = "${var.image_id}"
}

resource "null_resource" "configuration" {
  triggers = {
    linode_id  = "${module.vm.linode_id}"
    ip_address = "${module.vm.ip_address}"
    content    = "${data.template_file.config.rendered}"
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${module.vm.ip_address}"
  }

  provisioner "file" {
    content     = "${data.template_file.config.rendered}"
    destination = "/opt/deploy/config.cfg"
  }

  provisioner "ansible" {
    plays {
      playbook = {
        file_path = "${path.module}/ansible/main.yml"
      }
    }

    defaults {
      extra_vars = {
        ansible_python_interpreter = "/usr/bin/python3"
      }
    }

    remote {
      skip_install        = true
      bootstrap_directory = "/opt/deploy"
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
