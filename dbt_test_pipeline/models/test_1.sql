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
 a.field_a as field_a_ind,
 b.field_a as field_a_eng,
 a.field_b,
 current_timestamp as inserted_at,
 a.partition_date as partition_date
from
  {{ source('dummy_source', 'table_a') }} a
join
  {{ source('dummy_source', 'table_b') }} b
on
  a.field_b = b.field_b
  and a.partition_date = b.partition_date
{% if is_incremental() %}
where
  a.partition_date = "{{ var('execution_date') }}"
  and b.partition_date = "{{ var('execution_date') }}"
{% endif %}