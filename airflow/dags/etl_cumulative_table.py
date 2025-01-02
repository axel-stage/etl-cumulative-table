from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

default_args = {
    "owner": "airflow",
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "execution_timeout": timedelta(minutes=3),
    "depends_on_past": False,
    "wait_for_downstream": False,
}

with DAG(
  dag_id = "etl_cumulative_table",
  start_date = datetime(2024,12,1),
  catchup = True,
  schedule = "@daily",
  template_searchpath="/opt/airflow/query",
  default_args = default_args,
  tags=["postgres", "test"]
) as dag:

  sales_daily_populate = SQLExecuteQueryOperator(
        task_id="sales_daily_populate",
        conn_id="postgres",
        sql="sales_daily_populate.sql"
  )

  sales_daily_cumulate = SQLExecuteQueryOperator(
        task_id="sales_daily_cumulate",
        conn_id="postgres",
        sql="sales_daily_cumulate.sql"
  )

  sales_daily_populate >> sales_daily_cumulate