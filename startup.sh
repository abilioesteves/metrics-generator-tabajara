#!/bin/bash
set -e
set -x

export LOCAL_IP=$(ip route get 8.8.8.8 | grep -oE 'src ([0-9\.]+)' | cut -d ' ' -f 2)
if [ "$SERVER_NAME" == "" ]; then
    SERVER_NAME=$LOCAL_IP
fi

if [ "$REGISTRY_ETCD_URL" != "" ]; then
    echo "Will register this generator instance to ETCD REGISTRY at $REGISTRY_ETCD_URL..."
    etcd-registrar \
        --loglevel=info \
        --etcd-url=$REGISTRY_ETCD_URL \
        --etcd-base=$REGISTRY_ETCD_BASE \
        --service=$REGISTRY_SERVICE \
        --name=$(hostname) \
        --ttl=$REGISTRY_TTL&
fi

echo "Starting the almighty Metrics Generator Tabajara..."
metrics-generator-tabajara \
    --server-name=${SERVER_NAME} \
    --component-name=${COMPONENT_NAME} \
    --component-version=${COMPONENT_VERSION} \
    --accident-resource="${ACCIDENT_RESOURCE}" \
    --accident-ratio="${ACCIDENT_RATIO}" \
    --accident-type="$ACCIDENT_TYPE"
