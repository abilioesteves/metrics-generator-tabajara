#!/bin/bash
set -e
set -x

export LOCAL_IP=$(ip route get 8.8.8.8 | grep -oE 'src ([0-9\.]+)' | cut -d ' ' -f 2)
if [ "$SERVER_NAME" == "" ]; then
    SERVER_NAME=$LOCAL_IP
fi

echo "Starting the almighty Metrics Generator Tabajara..."
metrics-generator-tabajara \
    --server-name=${SERVER_NAME} \
    --component-name=${COMPONENT_NAME} \
    --component-version=${COMPONENT_VERSION} \
    --accident-resource="${ACCIDENT_RESOURCE}" \
    --accident-ratio="${ACCIDENT_RATIO}" \
    --accident-type="$ACCIDENT_TYPE"
