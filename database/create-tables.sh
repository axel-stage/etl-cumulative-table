#!/bin/bash
set -e
source database/.env
export PGPASSWORD=${DB_PASSWORD}
psql -v ON_ERROR_STOP=1 \
  --host=${DB_HOST} \
  --port=${DB_PORT} \
  --dbname=${DB_NAME} \
  --username=${DB_USER} <<-EOSQL
\i schema/sales_events.sql
\i schema/sales_daily.sql
\i schema/sales_daily_cumulate.sql
\q
EOSQL
