
{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}

link_hashkey: 'hk_service_request_agency_l'

foreign_hashkeys:
    - 'hk_service_request_h'
    - 'hk_agency_h'

source_models: 'stg_nyc_311'

src_ldts: 'ldts'
src_rsrc: 'rsrc'

{%- endset -%}

{{ datavault4dbt.link(yaml_metadata=yaml_metadata) }}
