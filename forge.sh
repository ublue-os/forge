#!/bin/bash

# Functions
function setup {
    echo -e "${YELLOW}Heating up the forge for the first time..${ENDCOLOR}"
    podman play kube forge-pod.yml --build --replace && podman logs --color -f ublue-os_forge-setup.ublue.local
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function up {
    echo -e "${YELLOW}Heating up the forge..${ENDCOLOR}"
    podman pod start ublue-os_forge
    echo -e "${GREEN}Done. Happy forging!${ENDCOLOR}"
}

function down {
    echo -e "${YELLOW}Cooling down the forge..${ENDCOLOR}"
    podman pod stop ublue-os_forge --ignore
    echo -e "${GREEN}Done. Have a nice day${ENDCOLOR}"
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
