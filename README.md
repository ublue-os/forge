# Universal Blue - Forge

On-premises Universal Blue. This projects intended is to provide the service units
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

As an entry point for all web components we use [Traefik](https://doc.traefik.io/traefik/)
as a reverse proxy. Based on URL routing it will redirect the traffic to the
right container instance.

The reverse proxy dashboard is available at <https://traefik.ublue.local>

### Container Registry

As container registry we make use of the [Docker Registry 2.0](https://hub.docker.com/_/registry/)
implementation for storing and distributing container images.

The container registry API is available at <https://registry.ublue.local/v2>

### Anvil

The blacksmith's work is done with [Ansible](https://docs.ansible.com/ansible/latest/index.html).

There are two methods of operating the forge, either via a [GUI](./docs/gui.md) available
at <https://forge.ublue.local> or via [just](./docs/just.md) command runner.

Details about the project and usage instructions are available in the [documentation](./docs/index.md)
section.

## Installation

### Pre-requisites

As many tools as possible are built-in but still we rely on some pre-requisites.
These tools and service are necessary to get started:

- [Podman](https://podman.io/)  
  Must be installed and a [podman socket](https://github.com/containers/podman/blob/main/docs/tutorials/socket_activation.md)
  in the user space must be active.

- [jq](https://jqlang.github.io/jq/)  
  Must be installed. It it currently needed in the setup process to parse certain parameters
  automatically for you

- The kernel parameter `net.ipv4.ip_unprivileged_port_start` must be set to `80`  
  This is because of podman's [shortcoming](https://github.com/containers/podman/blob/main/rootless.md#shortcomings-of-rootless-podman)
  to bind to ports `< 1024`. Our reverse-proxy is listening on port `80` and `443`
  for incoming traffic.

- [OpenSSH](https://www.openssh.com/)  
  Must be installed and the service activated. Ansible needs this to execute all the fancy
  commands on your host for you.

### Setup / Heat-Up / Cool-Down

For the initial setup and maintenance of the forge you can use the [forge.sh](forge.sh) script:

<!-- markdownlint-disable MD013 -->

| Command                | Description                                                 |
| ---------------------- | ----------------------------------------------------------- |
| `./forge.sh setup`     | Setup the forge for the first time or update existing setup |
| `./forge.sh heat-up`   | Start the forge                                             |
| `./forge.sh cool-down` | Stop the forge                                              |

<!-- markdownlint-enable MD013 -->

Details about what the setup does can be found [here](./docs/setup.md).
