#!/bin/bash
set -e
source database/.env
docker exec -i scheduler /bin/bash << EOF
airflow connections add 'postgres' \
    --conn-type 'postgres' \
    --conn-host ${DB_HOST_CONTAINER} \
    --conn-schema ${DB_NAME} \
    --conn-port ${DB_PORT_CONTAINER} \
    --conn-login ${DB_USER} \
    --conn-password ${DB_PASSWORD}
EOF
