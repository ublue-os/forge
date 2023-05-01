#!/bin/bash

# Setup Universal Blue Forge
podman play kube forge-pod.yml --build --replace && podman logs --color -f ublue-os_forge-setup.ublue.local
