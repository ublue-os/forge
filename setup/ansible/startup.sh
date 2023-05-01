#!/bin/sh

# Run setup only once
if [ ! -f /ansible/.startup-done ]; then
    ansible-playbook main.yml
    touch /ansible/.startup-done
fi
