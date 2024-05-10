# Variables

The following sections contains all important variables defined for daily usage.
All variables mentioned here can be declared in a yaml configuration file.

Have a look at the [configuration](./index.md#configuration) chapter for details
on where to find the configuration directory.

The following configuration variables are available and can be set to your liking:

<!-- markdownlint-disable MD013 -->

| Name                               | Type | Default value                                     | Description                                                      |
| ---------------------------------- | ---- | ------------------------------------------------- | ---------------------------------------------------------------- |
| `forge_git_repository_url`         | str  | <https://github.com/ublue-os/bluefin.git>         | Git repository url                                               |
| `forge_git_repository_destination` | str  | `{{ forge_data_volume_mountpoint }}`/data/bluefin | Git destination where repository is cloned to. </br> **_Note:_** |
| `forge_git_repository_version`     | str  | main                                              | Git repository branch or tag or commit version                   |
| `forge_registry_url`               | str  | registry.ublue.local                              | Container registry url                                           |

<!-- markdownlint-enable MD013 -->

On playbook launch your variable file will be imported into the ansible container so that
the settings are available during playbook execution.
