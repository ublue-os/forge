#!/bin/bash

# Functions
function setup {
    echo -e "${YELLOW}Creating secret configuration...${ENDCOLOR}"
    create_secrets
    echo ""
    echo -e "${YELLOW}Heating up forge for the first time...${ENDCOLOR}"
    podman play kube forge-pod.yml --configmap forge-pod-ConfigMap.yml --build --replace & PID_BUILD=$!
    wait ${PID_BUILD}
    echo -e "${YELLOW}Configuring Host system...${ENDCOLOR}"
    configure_host & PID_CONFIG=$!
    wait ${PID_CONFIG}
    echo ""
    echo -e "${YELLOW}Configuring forge...${ENDCOLOR}"
    podman logs --color -f ublue-os_forge-setup.ublue.local
    echo ""
    echo -e "${YELLOW}Cleaning up secrets...${ENDCOLOR}"
    delete_secrets
    show_info
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function up {
    echo -e "${YELLOW}Heating up forge...${ENDCOLOR}"
    podman pod start ublue-os_forge
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function down {
    echo -e "${YELLOW}Cooling down forge...${ENDCOLOR}"
    podman pod stop ublue-os_forge --ignore
    echo -e "${GREEN}Done. Have a nice day${ENDCOLOR}"
}

function configure_host {
    if [ ! -f ~/.config/.ublue-os_forge-host-setup-done ];
    then
        echo "adding ssh public key to ~/.ssh/authorized_keys"
        VOLUME_DIR="$(podman volume inspect ublue-os_forge-certs | jq -r '.[0].Mountpoint')"
        SSH_PUBLIC_KEY_FILE="${VOLUME_DIR}/ssh/ublue-os_forge-id_ed25519.pub"
        SSH_PUBLIC_KEY="$(cat ${SSH_PUBLIC_KEY_FILE})"
        echo "#uBlue forge ssh key" >> ~/.ssh/authorized_keys
        echo "$SSH_PUBLIC_KEY" >> ~/.ssh/authorized_keys
        touch ~/.config/.ublue-os_forge-host-setup-done
    else
        echo "Host system already configured. Nothing to do..."
    fi
}

function create_secrets {
    # Get user input
    echo -e "${YELLOW}Gathering user input${ENDCOLOR}"
    read -s -p "Enter sudo password for user $USER: " ANSIBLE_FORGE_HOST_BECOME_PASSWORD
    cat <<EOF | jq '.|map_values(@base64)' | podman secret create ublue-os_forge-secure - >/dev/null
    {
    "ANSIBLE_FORGE_HOST_USER": "$USER",
    "ANSIBLE_FORGE_HOST_BECOME_PASSWORD": "${ANSIBLE_FORGE_HOST_BECOME_PASSWORD}"
    }
EOF
}

function delete_secrets {
    podman secret rm ublue-os_forge-secure
}

function show_info {
    VOLUME_DIR="$(podman volume inspect ublue-os_forge-certs | jq -r '.[0].Mountpoint')"
    echo -e "${GREEN}Forge is available at: https://forge.ublue.local${ENDCOLOR}"
    echo -e "${GREEN}Make sure to install the root certificate from ${VOLUME_DIR}/tls/ublue-os_forge-root.pem${ENDCOLOR}"
}

# Bash colors
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

# Main
case "$1" in
    setup)
        setup
    ;;
    heat-up)
        up
    ;;
    cool-down)
        down
    ;;
    *)
        echo "Invalid argument: please provide 'heat-up', 'cool-down', or 'setup'"
    ;;
esac
