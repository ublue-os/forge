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
implementation for storing and distributing container images.

The container registry API is available at <https://registry.ublue.local/v2>

### Anvil

The blacksmith's work is done with [Ansible](https://docs.ansible.com/ansible/latest/index.html).

There are two methods of operating the forge, either via a GUI available at <https://forge.ublue.local>
or via [just command runner](https://github.com/casey/just).

Detailed usage instructions are available in the [documentation](./docs/index.md) section.

## Handling the forge

You can use the `forge.sh` to **setup**, **heat-up** or **cool-down** the forge.

<!-- markdownlint-disable MD013 -->

| Command                | Description                                                 |
| ---------------------- | ----------------------------------------------------------- |
| `./forge.sh setup`     | Setup the forge for the first time or update existing setup |
| `./forge.sh heat-up`   | Start the forge                                             |
| `./forge.sh cool-down` | Stop the forge                                              |

<!-- markdownlint-enable MD013 -->
