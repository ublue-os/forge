# forge
On-premises Universal Blue

This repo is intended to provide the service units necessary to set up a self-hosted OS forge for custom images.

Imagine something like a home lab or a university lab:

1. Deploy forge
2. Go into the webui, clone in your favorite uBlue repo and make changes
3. Forge automatically starts to build and images
4. PXE boot the clients, select ublue in the menu
5. Eat tacos
6. Return to a fully deployed lab with centralized package management

### Components

We need:

- webui git frontend to replicate "self hosted ublue" 
- a registry
- a certificate authority
- wireguard configs for all of it so people can self host their own personal mirror
