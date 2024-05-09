# bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
FORGE_POD_DATA_DIR="$(podman volume inspect ublue-os_forge-data | jq -r '.[0].Mountpoint')"
MOUNTPOINT_SYMLINK="$SCRIPT_DIR/mountpoint"

echo "Preparing mount"
if [ -L $MOUNTPOINT_SYMLINK ]; then
    echo "Existing symlink found. Doing nothing"
else
    echo "No existing symlink found. Creating new"
    ln -s $FORGE_POD_DATA_DIR $MOUNTPOINT_SYMLINK
fi