# Universal Blue - Forge

On-premises Universal Blue. This repository is intended to provide the service units
necessary to set up a self-hosted OS forge for custom images.

> **Warning**
> This project is "work in progress" and not ready for production

## Vision

Imagine something like a home lab or a university lab:

1. Deploy forge
2. Go into the WebUI, clone in your favorite uBlue repo and make changes
3. Forge automatically starts to build the images
4. PXE boot the clients, select ublue in the menu
5. Eat tacos
6. Return to a fully deployed lab with centralized package management

## What we have so far

We are still working on making the vision a reality. The following has been
implemented so far:

### Certificate Authority

We use a [Minica](https://github.com/jsha/minica) as simple CA to generate a
key pair and a root certificate for `*.ublue.local`. The wildcard certificate is
then made available to all other components and are valid for 2 years and 30 days.

### Reverse Proxy

As an entry point for all components we use [Traefik](https://doc.traefik.io/traefik/) as
a reverse proxy. Based on URL routing it will redirect the traffic to the
right container instance.

The reverse proxy dashboard is available at <https://traefik.ublue.local>

### Container Registry

As container registry we make use of the [Docker Registry 2.0](https://hub.docker.com/_/registry/)
implementation for storing and distributing container images

The container registry API is available at <https://registry.ublue.local/v2>

### Anvil

The blacksmith's work is done with [Ansible](https://docs.ansible.com/ansible/latest/index.html).

The shiny GUI is missing but this should not shy us away. See [usage](#usage) for instructions.

## Handling the forge

You can use the `forge.sh` to **setup**, **heat-up** and **cool-down** the forge.

<!-- markdownlint-disable MD013 -->

| Command                | Description                                                 |
| ---------------------- | ----------------------------------------------------------- |
| `./forge.sh setup`     | Setup the forge for the first time or update existing setup |
| `./forge.sh heat-up`   | Start the forge                                             |
| `./forge.sh cool-down` | Stop the forge                                              |

<!-- markdownlint-enable MD013 -->

### Usage

Once the forge has been setup the following recipes are available via [just command runner](https://github.com/casey/just).

<!-- markdownlint-disable MD013 -->

| Just recipe           | Input argument          | Default argument value                      | Description                                  |
| --------------------- | ----------------------- | ------------------------------------------- | -------------------------------------------- |
| `forge_project-clone` | `forge_config_var_file` | $HOME/ublue-os_forge/forge_default_vars.env | Clone git project repository                 |
| `forge_project-build` | `forge_config_var_file` | $HOME/ublue-os_forge/forge_default_vars.env | Build container image and upload to registry |

<!-- markdownlint-enable MD013 -->

All available settings for the `forge_config_var_file` are documented in the [variables.md](./docs/variables.md)
file. To launch a recipe you simple run:

```sh
just -f forge.just {{ recipe_name }} {{ forge_config_var_file }}
```

**_Example:_**

```sh
just -f forge.just forge_project-clone /var/home/stephan/ublue-os_forge/my-forge-project.env
```

In case you don't have [just command runner](https://github.com/casey/just) available.
Have a look at the [forge.just](./forge.just) file. It easy enough to understand which commands
are executed via the just recipes.
