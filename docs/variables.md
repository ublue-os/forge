# Variables

The following sections contains all important variables defined for daily usage.
All variables mentioned here can be declared in a line-delimited file of environment variables.

An example file on the host system with all variables available will be created on setup
for you. By default it can be found under `$HOME/ublue-os_forge/forge_default_vars.env`.

On playbook launch the variable file will be imported into the ansible container so that
the settings are available during playbook execution.

## group_vars/all/data.yml

In the [data.yml](../ansible/group_vars/all/data.yml) all variables are defined
which are used in the context of the data handling.

<!-- markdownlint-disable MD013 -->

| name                                     | type | environment variable | default value                               | description                                   |
| ---------------------------------------- | ---- | -------------------- | ------------------------------------------- | --------------------------------------------- |
| `forge_data_path`                        | str  | `FORGE_DATA_PATH`    | $HOME/ublue-os_forge                        | Path where forge will store files per default |
| `forge_data_default_variables_file_path` | str  |                      | $HOME/ublue-os_forge/forge_default_vars.env | Path to default configuration file            |

<!-- markdownlint-enable MD013 -->

## group_vars/all/git.yml

In the [git.yml](../ansible/group_vars/all/git.yml/) all variables are defined which are
used in the context of the git repositories.

<!-- markdownlint-disable MD013 -->

| name                               | type | environment variable               | default value                             | description                                    |
| ---------------------------------- | ---- | ---------------------------------- | ----------------------------------------- | ---------------------------------------------- |
| `forge_git_repository_url`         | str  | `FORGE_GIT_REPOSITORY_URL`         | <https://github.com/ublue-os/bluefin.git> | Git repository url                             |
| `forge_git_repository_destination` | str  | `FORGE_GIT_REPOSITORY_DESTINATION` | $HOME/ublue-os/forge/bluefin              | Git destination where repository is cloned to  |
| `forge_git_repository_version`     | str  | `FORGE_GIT_REPOSITORY_VERSION`     | main                                      | Git repository branch or tag or commit version |

<!-- markdownlint-enable MD013 -->

## group_vars/all/registry.yml

In the [registry.yml](../ansible/group_vars/all/registry.yml) all variables are defined
which are used in the context of the container registry.

<!-- markdownlint-disable MD013 -->

| name                 | type | environment variable | default value        | description            |
| -------------------- | ---- | -------------------- | -------------------- | ---------------------- |
| `forge_registry_url` | str  | `FORGE_REGISTRY_URL` | registry.ublue.local | Container registry url |

<!-- markdownlint-enable MD013 -->
