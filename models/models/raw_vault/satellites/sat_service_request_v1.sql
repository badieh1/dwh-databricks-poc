
{{ config(materialized='view') }}

{%- set yaml_metadata -%}
sat_v0: 'sat_service_request_v0'
hashkey: 'hk_service_request_h'
hashdiff: 'hd_service_request_s'
src_ldts: 'ldts'
src_rsrc: 'rsrc'
ledts_alias: 'ledts'
add_is_current_flag: true
{%- endset -%}

{{ datavault4dbt.sat_v1(yaml_metadata=yaml_metadata) }}
