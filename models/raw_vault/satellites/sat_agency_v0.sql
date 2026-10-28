
{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}

parent_hashkey: 'hk_agency_h'

src_hashdiff: 'hd_agency_s'

src_payload:
    - agency_name

source_model: 'stg_nyc_311'

src_ldts: 'ldts'
src_rsrc: 'rsrc'

{%- endset -%}

{{ datavault4dbt.sat_v0(yaml_metadata=yaml_metadata) }}
