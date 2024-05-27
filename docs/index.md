# Universal Blue - Forge Documentation

On-premises Universal Blue provides the service units necessary to set up a self-hosted
OS forge for custom images.

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
symlink this folder to a path more rememberable. For example you can do the following:

```sh
FORGE_POD_DATA_DIR="$(podman volume inspect ublue-os_forge-data | jq -r '.[0].Mountpoint')"
ln -s $FORGE_POD_DATA_DIR $HOME/ublue-os_forge-data
```

With this the data folder would be available in your home directory under `~/ublue-os_forge-data`

In that folder you will find an **examples** folder with example configurations similar to this:

```yaml
## ublue-os forge example configuration
## For more details got to https://github.com/ublue-os/forge/blob/main/docs/variables.md
---
forge_git_repository_url: https://github.com/ublue-os/bluefin.git
forge_git_repository_destination: "/var/home/stephan/.local/share/containers/storage/volumes/ublue-os_forge-data/_data/data/bluefin"
forge_container_extra_args:
  - --build-arg="BASE_IMAGE_NAME=silverblue"
  - --build-arg="IMAGE_FLAVOR=main"
  - --build-arg="AKMODS_FLAVOR=main"
  - --build-arg="FEDORA_MAJOR_VERSION=39"
  - --build-arg="TARGET_BASE=bluefin"
```

These files are a good starting point for your custom configuration. Simple copy those examples
you are interested in modify them to your liking.

Details about the available variables are documented [here](./variables.md).

## Usage

There are two methods of operating the forge, either via a [GUI](./gui.md) available
at <https://forge.ublue.local> or via [just](./just.md) command runner.
