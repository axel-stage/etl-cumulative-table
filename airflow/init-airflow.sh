airflow db init
airflow users create \
  --username ${USERNAME} \
  --password ${PASSWORD} \
  --firstname ${FIRSTNAME} \
  --lastname ${LASTNAME} \
  --role ${ROLE} \
  --email ${EMAIL}
airflow connections add ${CONNECTION_NAME} \
    --conn-type ${CONNECTION_TYPE} \
    --conn-host ${CONNECTION_HOST} \
    --conn-port ${CONNECTION_PORT} \
    --conn-schema ${CONNECTION_SCHEMA} \
    --conn-login ${CONNECTION_LOGIN} \
    --conn-password ${CONNECTION_PASSWORD}