#!/bin/bash

# Functions
function setup {
    echo -e "${YELLOW}Checking pre-requisites...${ENDCOLOR}"
    check_prerequisites
    echo -e "${YELLOW}Creating secret configuration...${ENDCOLOR}"
    create_secrets
    echo -e "${YELLOW}Heating up forge for the first time...${ENDCOLOR}"
    podman play kube forge-pod.yml --build --replace & PID_BUILD=$!
    wait ${PID_BUILD}
    echo -e "${YELLOW}Configuring host system...${ENDCOLOR}"
    configure_host & PID_CONFIG=$!
    wait ${PID_CONFIG}
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
        cp -f ${VOLUME_DIR}/tls/ublue-os_forge-root.pem ~/Downloads
        touch ~/.config/.ublue-os_forge-host-setup-done
        echo ""
    else
        echo "Host system already configured. Nothing to do..."
        echo ""
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
    echo ""
}

function delete_secrets {
    podman secret rm ublue-os_forge-secure
}

function check_prerequisites {
    echo -e "${YELLOW}Checking sshd service${ENDCOLOR}"
    SSH_SERVICE_STATUS="$(systemctl is-active sshd)"
    if [ "${SSH_SERVICE_STATUS}" = "inactive" ];
    then
        echo -e "${RED}It looks like your sshd service is not running.${ENDCOLOR}"
        echo -e "${RED}Make sure to configure and start it first.${ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}sshd service is ${SSH_SERVICE_STATUS}${ENDCOLOR}"
        echo ""
    fi
    echo -e "${YELLOW}Checking podman installation${ENDCOLOR}"
    PODMAN_PATH=$(which podman 2>/dev/null || echo 'FALSE')
    if [ "$PODMAN_PATH" == "FALSE" ];
    then
        echo -e "${RED}It looks like podman is not installed.${ENDCOLOR}"
        echo -e "${RED}Make sure to install it first.${ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}podman is installed${SSH_SERVICE_STATUS}${ENDCOLOR}"
        echo ""
    fi
    echo -e "${YELLOW}Checking jq installation${ENDCOLOR}"
    JQ_PATH=$(which jq 2>/dev/null || echo 'FALSE')
    if [ "$JQ_PATH" == "FALSE" ];
    then
        echo -e "${RED}It looks like jq is not installed.${ENDCOLOR}"
        echo -e "${RED}Make sure to install it first.${ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}jq is installed${SSH_SERVICE_STATUS}${ENDCOLOR}"
        echo ""
    fi
}

function show_info {
    VOLUME_DIR="$(podman volume inspect ublue-os_forge-certs | jq -r '.[0].Mountpoint')"
    echo -e "${GREEN}uBlue forge is available at: https://forge.ublue.local${ENDCOLOR}"
    echo -e "${GREEN}To trust the certificate in your Browser of choice, make sure to import the root certificate from:${ENDCOLOR}"
    echo -e "${GREEN}$HOME/Downloads/tls/ublue-os_forge-root.pem${ENDCOLOR}"
    echo ""
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
