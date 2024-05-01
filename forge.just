# ublue-os forge just configuration

# Show all messages from this boot
forge_clone-repository:
    podman exec ublue-os_forge-anvil-ansible.ublue.local ansible-playbook playbooks/project_clone.yml

forge_build-image:
    podman exec ublue-os_forge-anvil-ansible.ublue.local ansible-playbook playbooks/project_build.yml