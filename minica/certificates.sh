#!/bin/sh
## Create SSH keys and certificates for uBlue-OS Forge

CERTIFICATE_DIRECTORY="/certs"
SSH_KEY_NAME="ublue-os_forge-id_ed25519"
TLS_ROOT_CERTIFICATE_NAME="ublue-os_forge-root"

if [ ! -f ${CERTIFICATE_DIRECTORY}/ssh/${SSH_KEY_NAME} ];
then
    echo "uBlue Forge SSH key not present. Creating new key..."
    mkdir ${CERTIFICATE_DIRECTORY}/ssh -p
    # Generate SSH key
    ssh-keygen -o -a 100 -t ed25519 -f ${CERTIFICATE_DIRECTORY}/ssh/${SSH_KEY_NAME} -C "forge@ublue.local"
else
    echo "Existing uBlue Forge SSH key found. Nothing to do..."
fi

# Creating TLS certificates
if [ ! -f ${CERTIFICATE_DIRECTORY}/tls/${TLS_ROOT_CERTIFICATE_NAME}.pem ];
then
    echo "uBlue Forge TLS root not certificate present. Creating new certificates..."
    mkdir ${CERTIFICATE_DIRECTORY}/tls -p
    # Generate TLS certificates
    minica --domains "*.ublue.local,ublue.local,localhost" --ip-addresses 127.0.0.1 -ca-cert "${CERTIFICATE_DIRECTORY}/tls/${TLS_ROOT_CERTIFICATE_NAME}.pem" -ca-key "${CERTIFICATE_DIRECTORY}/tls/${TLS_ROOT_CERTIFICATE_NAME}-key.pem"
else
    echo "Existing uBlue Forge TLS root certificate found. Nothing to do..."
fi
