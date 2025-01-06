#!/bin/bash
set -e
# connect to postgres db with postgres role
psql -v ON_ERROR_STOP=1 \
    --username ${POSTGRES_USER} \
    --dbname ${POSTGRES_DB} <<-EOSQL
\timing
\conninfo

-- role
CREATE ROLE ${DB_USER}
WITH LOGIN
PASSWORD '$PGPASSWORD'
CONNECTION LIMIT 10
VALID UNTIL 'infinity'
NOCREATEDB
NOSUPERUSER
NOCREATEROLE
NOINHERIT
NOBYPASSRLS
NOREPLICATION;

-- database
CREATE DATABASE ${DB_NAME}
WITH OWNER ${DB_USER}
TEMPLATE template1
ENCODING='UTF8';
EOSQL

# connect to created db with postgres role
psql -v ON_ERROR_STOP=1 \
    --username ${POSTGRES_USER} \
    --dbname ${DB_NAME} <<-EOSQL
\timing
\conninfo

-- schema
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA IF NOT EXISTS ${SCHEMA} AUTHORIZATION ${DB_USER};

-- extension
CREATE EXTENSION IF NOT EXISTS dblink
WITH SCHEMA ${SCHEMA}
VERSION '1.2';

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"
WITH SCHEMA ${SCHEMA};

CREATE EXTENSION IF NOT EXISTS adminpack
WITH SCHEMA pg_catalog
VERSION '2.0';
\q
EOSQL

# connect to created db with dbuser role
psql -v ON_ERROR_STOP=1 \
  --username=${DB_USER} \
  --dbname=${DB_NAME} <<-EOSQL
\timing
\conninfo
\i schema/sales_events.sql
\i schema/sales_daily.sql
\i schema/sales_daily_cumulate.sql
\set sales_events ${SALES_EVENTS}
\set products ${PRODUCTS}
\i query/sales_events_populate.sql
\q
EOSQL
