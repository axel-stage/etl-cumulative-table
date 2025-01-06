#!/bin/bash
set -e
source database/.env
docker exec -i scheduler /bin/bash << EOF
airflow connections add 'postgres' \
    --conn-type 'postgres' \
    --conn-host ${DATABASE_CONTAINER_NAME} \
    --conn-schema ${DB_NAME} \
    --conn-port ${DATABASE_CONTAINER_PORT} \
    --conn-login ${DB_USER} \
    --conn-password ${PGPASSWORD}
EOF
