from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

default_args = {
    "owner": "airflow",
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "execution_timeout": timedelta(minutes=1),
    "wait_for_downstream": False,
    "depends_on_past": True, # mandatory, keeps a task from getting triggered if the previous schedule for the task hasn’t succeeded
}

with DAG(
  dag_id = "etl_cumulative_table",
  description='etl process for daily sales data to build a cumulative table',
  start_date = datetime(2024,12,1),
  max_active_runs = 1, # mandatory, parallel dag runs are not allowed
  catchup = True,
  schedule = "@daily",
  template_searchpath="/opt/airflow/query",
  default_args = default_args,
  tags=["postgres", "etl"]
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