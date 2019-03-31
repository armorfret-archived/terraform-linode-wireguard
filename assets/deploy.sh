#!/usr/bin/env bash

set -euo pipefail

DEPLOY_DIR=/opt/deploy
(
    cd "$DEPLOY_DIR"
    git pull

    export PS1=""
    source env/bin/activate
    ansible-playbook main.yml
)
