# ublue-os forge just configuration

## recipes

forge_project-clone forge_config_var_file:
    podman exec ublue-os_forge-anvil-ansible.ublue.local ansible-playbook ansible/playbooks/project_clone.yml --extra-vars "@/data/{{forge_config_var_file}}"

forge_project-build forge_config_var_file:
    podman exec ublue-os_forge-anvil-ansible.ublue.local ansible-playbook ansible/playbooks/project_build.yml  --extra-vars "@/data/{{forge_config_var_file}}"
