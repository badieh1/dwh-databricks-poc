
{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}

parent_hashkey: 'hk_service_request_h'

src_hashdiff: 'hd_service_request_s'

src_payload:
    - created_date
    - closed_date
    - complaint_type
    - descriptor
    - location_type
    - incident_zip
    - city
    - borough
    - status
    - resolution_description
    - resolution_action_updated_date
    - open_data_channel_type
    - latitude
    - longitude

source_model: 'stg_nyc_311'

src_ldts: 'ldts'
src_rsrc: 'rsrc'

{%- endset -%}

{{ datavault4dbt.sat_v0(yaml_metadata=yaml_metadata) }}
