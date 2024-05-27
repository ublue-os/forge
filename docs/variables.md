# Variables

On this page all important variables defined for daily usage are documented.
All variables mentioned here can be declared in a `yaml` configuration file.

Have a look at the [configuration](./index.md#configuration) chapter for details
on where to find the configuration directory.

The following configuration variables are available and can be set to your liking:

<!-- markdownlint-disable MD013 -->

| Name                               | Type | Default value                                                           | Description                                                                                                                  |
| ---------------------------------- | ---- | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `forge_container_name`             | str  | Project name derived from `forge_git_repository_url` Example: `bluefin` | Container image name.                                                                                                        |
| `forge_container_tag`              | str  | Evaluates to: `YYY-MM-DD_HHMMSS` Example: `2024-05-26_192206`           | Container image tag.                                                                                                         |
| `forge_container_file`             | str  | Containerfile                                                           | Path to the Containerfile for Podman to build                                                                                |
| `forge_container_format`           | str  | oci                                                                     | Format of the image Podman will build. Can be either `oci` or `docker`                                                       |
| `forge_container_extra_args`       | list | []                                                                      | List of extra arguments which gets passed to the podman build process. Example: `[--build-arg="BASE_IMAGE_NAME=silverblue"]` |
| `forge_git_repository_url`         | str  |                                                                         | Git repository url                                                                                                           |
| `forge_git_repository_destination` | str  |                                                                         | Git destination where repository is cloned to.                                                                               |
| `forge_git_repository_version`     | str  | main                                                                    | Git repository branch or tag or commit version                                                                               |
| `forge_registry_url`               | str  | registry.ublue.local                                                    | Container registry url                                                                                                       |

<!-- markdownlint-enable MD013-->
