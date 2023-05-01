#!/bin/bash
cat <<EOM
install-dev-tools.sh
=============================================
This script customizes the devcontainer setup
=============================================
EOM
# Bash colors
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

## Update system
echo ""
echo -e "${YELLOW}Updating OS${ENDCOLOR}"
echo ""
sudo apk update && sudo apk upgrade

## Install additional tools
echo ""
echo -e "${YELLOW}Installing additional tools${ENDCOLOR}"
echo ""
sudo apk add git-extras --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
sudo apk add py3-pip
python3 -m pip install --user pipx
python3 -m pipx ensurepath
pipx install poetry

## Install podman remote
echo ""
echo -e "${YELLOW}Installing podman-remote${ENDCOLOR}"
echo ""
PODMAN_SOURCE=https://github.com/containers/podman/releases/download/v4.4.4/podman-remote-static-linux_amd64.tar.gz
PODMAN_TMP=/tmp/podman.tar.gz
wget -O $PODMAN_TMP $PODMAN_SOURCE
sudo tar -xf $PODMAN_TMP -C /tmp
sudo mv /tmp/bin/podman-remote-static-linux_amd64 /usr/bin/podman
podman system connection add devcontainer_host unix:///run/podman/podman.sock
sudo rm -rf /tmp/bin

# Add git commit template
echo ""
echo -e "${YELLOW}Configuring git${ENDCOLOR}"
echo ""
git config --local commit.template .gitmessage

# Install python dependencies
echo ""
echo -e "${YELLOW}Installing python dependencies${ENDCOLOR}"
echo ""
poetry install -C /workspaces/forge/ansible

# Install ansible dependencies
echo ""
echo -e "${YELLOW}Installing ansible dependencies${ENDCOLOR}"
echo ""
ansible-galaxy collection install -r /workspaces/forge/ansible/collections/requirements.yml

# Finish
echo ""
echo -e "${GREEN}Done. Happy coding!${ENDCOLOR}"
echo ""
