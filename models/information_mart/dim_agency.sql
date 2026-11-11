
{{ config(materialized='view') }}

SELECT
    h.hk_agency_h AS agency_key,
    h.agency,
    s.agency_name

FROM {{ ref('hub_agency') }} h

LEFT JOIN {{ ref('sat_agency_v0') }} s
    ON h.hk_agency_h = s.hk_agency_h
