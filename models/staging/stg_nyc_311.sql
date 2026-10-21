
{{ config(materialized='view') }}

{%- set yaml_metadata -%}

source_model: 'src_nyc_311'

ldts: 'ldts'
rsrc: 'rsrc'

hashed_columns:

    hk_service_request_h:
        - unique_key

    hk_agency_h:
        - agency

    hk_service_request_agency_l:
        - unique_key
        - agency

    hd_service_request_s:
        is_hashdiff: true
        columns:
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

    hd_agency_s:
        is_hashdiff: true
        columns:
            - agency_name

enable_ghost_records: false

{%- endset -%}

{{ datavault4dbt.stage(yaml_metadata=yaml_metadata) }}
