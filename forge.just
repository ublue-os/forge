# ublue-os forge just configuration

## default

default :=  "'${HOME}'/ublue-os_forge/forge_default_vars.env"

## recipes

forge_project-clone forge_config_var_file=default:
    podman exec --env-file '{{forge_config_var_file}}' ublue-os_forge-anvil-ansible.ublue.local ansible-playbook playbooks/project_clone.yml

forge_project-build forge_config_var_file=default:
    podman exec --env-file '{{forge_config_var_file}}' ublue-os_forge-anvil-ansible.ublue.local ansible-playbook playbooks/project_build.yml
