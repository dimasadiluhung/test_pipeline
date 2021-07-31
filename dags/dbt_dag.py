from airflow import DAG
from datetime import datetime
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator

default_args = {
    'owner': 'dimas',
    'depend_on_past': False,
    'start_date': datetime(2021, 7, 1, 17, 0),
}

dag = DAG(
    'dbt_dag',
    default_args=default_args,
    schedule_interval="0 0 * * *"
)

dbt_exec = KubernetesPodOperator(
    task_id='execute_dbt',
    name='execute-dbt',
    namespace='default',
    image="gcr.io/turnkey-env-319809/dbt_test_pipeline:latest",
    cmds=["dbt", "run", "--vars"],
    arguments=["{execution_date: {{ ds }}}"],
    is_delete_operator_pod=True,
    dag=dag
)
