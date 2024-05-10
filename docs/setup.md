# Forge setup

The initial setup and maintenance of the forge you can use the `forge.sh` script:

<!-- markdownlint-disable MD013 -->

| Command                | Description                                                 |
| ---------------------- | ----------------------------------------------------------- |
| `./forge.sh setup`     | Setup the forge for the first time or update existing setup |
| `./forge.sh heat-up`   | Start the forge                                             |
| `./forge.sh cool-down` | Stop the forge                                              |

<!-- markdownlint-enable MD013 -->

## What happens during setup

Just in case you haven't have a look at the [forge.sh](../forge.sh) script. The following
things happen during the setup:

1. The [pre-requisites](../README.md#pre-requisites) are checked

2. You will be asked for your user credentials
   This is not to spy on you. We need them to execute the [configure_host.yml](../anvil/ansible/playbooks/configure_host.yml).
   It will configure the necessary settings so you don't have to do that manually.
   See step 7.

3. A podman network `ublue-os_forge` is created. All containers from this setup will be
   attached to it in the next step

4. All containers are built and spun up according to the [forge-pod.yml](../forge-pod.yml)
   specification.

5. The forge SSH key is added to your `~/.ssh/authorized_keys` file.
   The root certificate and key are created during container build mentioned in the
   previous step.

6. The forge root certificate is copied to the [data](index.md#configuration) directory.

7. The [configure_host.yml](../anvil/ansible/playbooks/configure_host.yml) playbook mentioned
   in step 2 is executed.
   This will created the necessary host entries in `/etc/hosts`, copy the forge root certificate
   to `/etc/pki/ca-trust/source/anchors/`, `update-ca-trust` and create the example configuration
   in the [data](index.md#configuration) directory.
