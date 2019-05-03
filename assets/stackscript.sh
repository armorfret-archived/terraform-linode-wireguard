#!/usr/bin/env bash
# <UDF name="users" Label="User list (comma-delimited)" default="one,two,three,four" />
# <UDF name="deploy_repo" Label="Ansible deploy repo" default="https://github.com/akerl/deploy-wireguard-server" />

set -euo pipefail

apt update
apt upgrade -y
apt install -y python3-pip python3-dev build-essential git vim-nox
pip3 install ansible

git clone "$DEPLOY_REPO" /opt/deploy

exit

ansible-playbook --extra-vars=ansible_python_interpreter=/usr/bin/python3 /opt/deploy/linode/setup.yml
ansible-playbook --extra-vars=ansible_python_interpreter=/usr/bin/python3 /opt/deploy/main.yml
