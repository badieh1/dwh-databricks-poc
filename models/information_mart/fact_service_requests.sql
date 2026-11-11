
{{ config(materialized='view') }}

WITH current_requests AS (

    SELECT *
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

)

SELECT
    h.unique_key,
    l.hk_agency_h AS agency_key,
    sha2(s.complaint_type, 256) AS complaint_type_key,
    sha2(s.borough, 256) AS borough_key,
    s.created_date,
    s.closed_date,
    s.status,
    1 AS request_count

FROM {{ ref('hub_service_request') }} h

LEFT JOIN current_requests s
    ON h.hk_service_request_h = s.hk_service_request_h

LEFT JOIN {{ ref('link_service_request_agency') }} l
    ON h.hk_service_request_h = l.hk_service_request_h
