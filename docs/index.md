# Universal Blue - Forge

On-premises Universal Blue. This repository is intended to provide the service units
necessary to set up a self-hosted OS forge for custom images.

## Configuration

Since we are using ansible in the background, all user configurations are loaded via
[`extra-vars`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#defining-variables-at-runtime)
at runtime. No worries on how things are plugged together, you only have to know where
to create your configuration files. That's all.

So, during forge setup a podman volume `ublue-os_forge-data` is created. All user configuration
etc. is stored there. You can inspect the volume with:

```sh
❯ podman volume inspect ublue-os_forge-data
[
     {
          "Name": "ublue-os_forge-data",
          "Driver": "local",
          "Mountpoint": "/var/home/stephan/.local/share/containers/storage/volumes/ublue-os_forge-data/_data",
          "CreatedAt": "2024-05-06T21:25:28.818751853+02:00",
          "Labels": {},
          "Scope": "local",
          "Options": {},
          "MountCount": 0,
          "NeedsCopyUp": true,
          "LockNumber": 98
     }
]
```

Under the `"Mountpoint:"` you find the actual path on your file system. I would recommend you
symlink this folder to a path more rememberable. For example you can do:

```sh
FORGE_POD_DATA_DIR="$(podman volume inspect ublue-os_forge-data | jq -r '.[0].Mountpoint')"
ln -s $FORGE_POD_DATA_DIR $HOME/ublue-os_forge-data
```

In that folder you will find an example configuration similar to this:

```yaml
## ublue-os forge extra-vars example configuration
## For more details got to https://github.com/ublue-os/forge/blob/main/docs/variables.md
---
forge_git_repository_url: https://github.com/ublue-os/bluefin.git
forge_git_repository_destination: /var/home/stephan/.local/share/containers/storage/volumes/ublue-os_forge-data/_data/data/bluefin
forge_git_repository_version: main
forge_registry_url: registry.ublue.local
```

This file acts as a template. Simple copy it and modify it to your liking. For each project
you want to handle with the forge you can create a dedicated file.

Details about the available variables are documented [here](./variables.md).

## Usage

There are two methods of operating the forge, either via a GUI available at <https://forge.ublue.local>
or via [just command runner](https://github.com/casey/just).

More details about either usage are available here:

- [GUI](./gui.md)
- [just command runner](./just.md)
