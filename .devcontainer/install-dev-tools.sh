# Bash colors
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

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
poetry install --no-root -C /workspaces/forge/ansible

# Install ansible dependencies
echo ""
echo -e "${YELLOW}Installing ansible dependencies${ENDCOLOR}"
echo ""
ansible-galaxy collection install -r /workspaces/forge/ansible/collections/requirements.yml

# Finish
echo ""
echo -e "${GREEN}Done. Happy coding!${ENDCOLOR}"
echo ""
