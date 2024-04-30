#!/bin/bash
# Variables
export FORGE_DOMAIN_NAME="ublue.local"
export FORGE_NETWORK_NAME="ublue-os_forge"
export FORGE_HOST_UID=$(id -u)
export FORGE_POD_CONFIGURATION="forge-pod.yml"
export FORGE_POD_NAME_PRE_AMBLE="ublue-os_forge-"
export FORGE_POD_NAME_REVERSE_PROXY=${FORGE_POD_NAME_PRE_AMBLE}rvproxy
export FORGE_POD_NAME_REGISTRY=${FORGE_POD_NAME_PRE_AMBLE}registry
export FORGE_POD_NAME_SETUP=${FORGE_POD_NAME_PRE_AMBLE}setup

# Functions
function setup {
    echo -e "${YELLOW}Checking pre-requisites...${ENDCOLOR}"
    check_prerequisites
    echo -e "${YELLOW}Creating secret configuration...${ENDCOLOR}"
    create_secrets
    echo -e "${YELLOW}Creating podman network...${ENDCOLOR}"
    create_network
    echo -e "${YELLOW}Heating up forge for the first time...${ENDCOLOR}"
    cat ${FORGE_POD_CONFIGURATION} | envsubst | podman play kube --build --replace --network "${FORGE_NETWORK_NAME}" - & PID_BUILD=$!
    wait ${PID_BUILD}
    echo -e "${YELLOW}Configuring host system pre-requisites...${ENDCOLOR}"
    configure_host_prerequisites & PID_CONFIG=$!
    wait ${PID_CONFIG}
    echo -e "${YELLOW}Configuring host system...${ENDCOLOR}"
    podman logs --color --follow "${FORGE_POD_NAME_SETUP}-ansible.${FORGE_DOMAIN_NAME}"
    echo ""
    echo -e "${YELLOW}Cleaning up secrets...${ENDCOLOR}"
    delete_secrets
    show_info
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function up {
    echo -e "${YELLOW}Heating up forge...${ENDCOLOR}"
    podman pod start ${FORGE_POD_NAME_REVERSE_PROXY}
    podman pod start ${FORGE_POD_NAME_REGISTRY}
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function down {
    echo -e "${YELLOW}Cooling down forge...${ENDCOLOR}"
    podman pod stop "${FORGE_POD_NAME_REVERSE_PROXY}" --ignore
    podman pod stop "${FORGE_POD_NAME_REGISTRY}" --ignore
    echo -e "${GREEN}Done. Have a nice day${ENDCOLOR}"
}

function configure_host_prerequisites {
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
        echo "Host system pre-requisites already configured. Nothing to do..."
        echo ""
    fi
}

function create_secrets {
    # Get user input
    echo -e "${YELLOW}Gathering user input${ENDCOLOR}"
    read -s -p "Enter sudo password for user $USER: " ANSIBLE_HOST_BECOME_PASSWORD
    cat <<EOF | jq '.|map_values(@base64)' | podman secret create ublue-os_forge-secure - >/dev/null
    {
    "ANSIBLE_HOST_USER": "$USER",
    "ANSIBLE_HOST_BECOME_PASSWORD": "${ANSIBLE_HOST_BECOME_PASSWORD}"
    }
EOF
    echo ""
}

function delete_secrets {
    podman secret rm ublue-os_forge-secure
}

function create_network {
    if ! podman network inspect "${FORGE_NETWORK_NAME}" &>/dev/null; then
        echo "Podman network ${FORGE_NETWORK_NAME} does not exist. Creating..."
        podman network create "${FORGE_NETWORK_NAME}"
    else
        echo "Podman network ${FORGE_NETWORK_NAME} already exists."
    fi
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
        echo -e "${GREEN}podman is installed${ENDCOLOR}"
        echo ""
    fi
    echo -e "${YELLOW}Checking podman socket service${ENDCOLOR}"
    PODMAN_SERVICE_STATUS="$(systemctl --user is-active podman.socket)"
    if [ "${PODMAN_SERVICE_STATUS}" != "active" ];
    then
        echo -e "${RED}It looks like your podman socket is not running.${ENDCOLOR}"
        echo -e "${RED}Make sure to configure and start it first.${ENDCOLOR}"
        echo -e "${YELLOW}Need help? -> https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md${ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}podman socket is ${PODMAN_SERVICE_STATUS}${ENDCOLOR}"
        echo ""
    fi
    echo -e "${YELLOW}Checking net.ipv4.ip_unprivileged_port_start${ENDCOLOR}"
    NET_IPV4_UNPRIV_PORT_START="$(sysctl -n net.ipv4.ip_unprivileged_port_start)"
    if [ "${NET_IPV4_UNPRIV_PORT_START}" -gt 80 ];
    then
        echo -e "${RED}Your net.ipv4.ip_unprivileged_port_start is set to ${NET_IPV4_UNPRIV_PORT_START}${ENDCOLOR}"
        echo -e "${RED}Make sure to configure net.ipv4.ip_unprivileged_port_start to <= 80${ENDCOLOR}"
        echo -e "${YELLOW}Need help? -> run 'sudo sysctl net.ipv4.ip_unprivileged_port_start=80' for this session or run 'sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80' for a permanent configuration${ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}net.ipv4.ip_unprivileged_port_start is ${NET_IPV4_UNPRIV_PORT_START}${ENDCOLOR}"
        echo ""
    fi
    echo -e "${YELLOW}Checking jq installation${ENDCOLOR}"
    JQ_PATH=$(which jq 2>/dev/null || echo 'FALSE')
    if [ "$JQ_PATH" == "FALSE" ];
    then
        echo -e "${RED}It looks like jq is not installed.${ENDCOLOR}"
        echo -e "${RED}Make sure to install it first.${ENDCOLOR}"
        echo -e "${YELLOW}Need help? -> https://jqlang.github.io/jq/download{ENDCOLOR}"
        exit 1
    else
        echo -e "${GREEN}jq is installed${ENDCOLOR}"
        echo ""
    fi
}

function show_info {
    echo -e "${GREEN}uBlue forge reverse-proxy is available at: https://traefik.${FORGE_DOMAIN_NAME}${ENDCOLOR}"
    echo -e "${GREEN}uBlue forge docker registry is available at: registry.${FORGE_DOMAIN_NAME}${ENDCOLOR}"
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
