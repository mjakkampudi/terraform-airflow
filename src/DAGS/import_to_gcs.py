from datetime import timedelta, datetime
from airflow import DAG
from airflow.contrib.sensors import file_sensor
from airflow.providers.google.cloud.transfers.local_to_gcs  import LocalFilesystemToGCSOperator
import pandas as pd


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.today(),
}

dag = DAG('file_to_gcs', default_args=default_args)

gcp_operator = LocalFilesystemToGCSOperator(
        task_id='file_to_gcs',
        src='/opt/airflow/dags/repo/cardio_train.csv',
        dst='cardio_data.csv',
        bucket='mj-dataset-bucket',
        gcp_conn_id='airflow_test',
        dag=dag
    )
