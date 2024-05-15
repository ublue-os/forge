# Variables

On this page all important variables defined for daily usage are documented.
All variables mentioned here can be declared in a `yaml` configuration file.

Have a look at the [configuration](./index.md#configuration) chapter for details
on where to find the configuration directory.

The following configuration variables are available and can be set to your liking:

<!-- markdownlint-disable MD013 -->

| Name                               | Type | Default value                                     | Description                                                                      |
| ---------------------------------- | ---- | ------------------------------------------------- | -------------------------------------------------------------------------------- |
| `forge_container_file`             | str  | Containerfile                                     | Path to the Containerfile for Podman to build                                    |
| `forge_container_format`           | str  | oci                                               | Format of the image Podman will build. Can be either `oci` or `docker`           |
| `forge_git_repository_url`         | str  | <https://github.com/ublue-os/bluefin.git>         | Git repository url                                                               |
| `forge_git_repository_destination` | str  | `{{ forge_data_volume_mountpoint }}`/data/bluefin | Git destination where repository is cloned to. Can be any directory on your host |
| `forge_git_repository_version`     | str  | main                                              | Git repository branch or tag or commit version                                   |
| `forge_registry_url`               | str  | registry.ublue.local                              | Container registry url                                                           |

<!-- markdownlint-enable MD013-->

**_Note:_** The `{{ forge_data_volume_mountpoint }}` points to your ublue-os_forge-data
podman volume.
