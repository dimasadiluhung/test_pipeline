FROM fishtownanalytics/dbt:0.19.1

WORKDIR /dbt_test_pipeline

COPY dbt_test_pipeline /dbt_test_pipeline/
COPY profiles.yml /root/.dbt/

ENTRYPOINT [ "entrypoint" ]