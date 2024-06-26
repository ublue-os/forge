# Bash colors
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

# Add Forge DEV DNS entries
echo ""
echo -e "${YELLOW}Adding DNS entries for ublue.local${ENDCOLOR}"
echo ""
DOCKER_HOST=$(getent hosts host.docker.internal | awk '{ print $1 }')
echo "$DOCKER_HOST registry.ublue.local" | sudo tee -a /etc/hosts

## Install SSL certificates
echo ""
echo -e "${YELLOW}Installing SSL certificates${ENDCOLOR}"
echo ""
sudo cp /data/ublue-os_forge-root.pem /usr/local/share/ca-certificates/ublue-os_forge-root.crt
sudo update-ca-certificates --fresh

## Update system
echo ""
echo -e "${YELLOW}Updating OS${ENDCOLOR}"
echo ""
sudo apt-get update && sudo apt-get upgrade -y

## Install additional tools
echo ""
echo -e "${YELLOW}Installing additional tools${ENDCOLOR}"
echo ""
sudo apt-get -y install --no-install-recommends git-extras gnupg2

## lazygit -> version specified in devcontainer.json
LAZYGIT_SOURCE=https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
LAZYGIT_TMP=/tmp/lazygit.tar.gz
wget -O $LAZYGIT_TMP $LAZYGIT_SOURCE
sudo tar -xf $LAZYGIT_TMP -C /usr/bin

# Add git commit template
echo ""
echo -e "${YELLOW}Configuring git${ENDCOLOR}"
echo ""
git config --local commit.template .gitmessage


# Install python dependencies
echo ""
echo -e "${YELLOW}Installing project dependencies${ENDCOLOR}"
echo ""
poetry install --no-root -C /workspaces/forge/anvil

# Install ansible dependencies
echo ""
echo -e "${YELLOW}Installing ansible dependencies${ENDCOLOR}"
echo ""
ansible-galaxy collection install --force -r /workspaces/forge/anvil/ansible/collections/requirements.yml

# Finish
echo ""
echo -e "${GREEN}Done. Happy coding!${ENDCOLOR}"
echo ""
