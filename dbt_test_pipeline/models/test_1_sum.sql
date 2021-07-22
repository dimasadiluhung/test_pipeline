{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
        partition_by={
            "field": "partition_date",
            "data_type": "date"
        }
    )
}}

select
 field_b,
 array[field_a_ind, field_a_eng] as lang,
 current_timestamp as inserted_at,
 a.partition_date as partition_date
from
  {{ ref('test_1') }} a
{% if is_incremental() %}
where
  partition_date = "{{ var('execution_date') }}"
{% endif %}