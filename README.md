terraform-linode-wireguard
=========

[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Terraform module that creates a [Linode](https://linode.com) with [wireguard](https://www.wireguard.com) running on it using [this Ansible code](https://github.com/akerl/deploy-wireguard-server/)

## Usage

```
module "vpn" {
  source  = "github.com/akerl/terraform-linode-wireguard"
  name = "vpn"

  users = [
    "alfa",
    "beta",
  ]
}
```

## License

terraform-linode-wireguard is released under the MIT License. See the bundled LICENSE file for details.
