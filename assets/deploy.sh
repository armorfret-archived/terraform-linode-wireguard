#!/usr/bin/env bash

set -euo pipefail

DEPLOY_DIR=/opt/algo
(
    cd "$DEPLOY_DIR"
    git pull

    export PS1=""
    source env/bin/activate
    ansible-playbook main.yml
)
