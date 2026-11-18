
{{ config(materialized='view') }}

WITH current_requests AS (

    SELECT *
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

)

SELECT
    h.unique_key,
    l.hk_agency_h AS agency_key,

    sha2(
        to_json(named_struct(
            'complaint_type', s.complaint_type,
            'descriptor', s.descriptor
        ), map('ignoreNullFields', 'false')),
        256
    ) AS complaint_detail_key,

    sha2(s.borough, 256) AS borough_key,

    CAST(DATE_FORMAT(s.created_date, 'yyyyMMdd') AS INT)
        AS created_date_key,

    HOUR(s.created_date) * 3600
        + MINUTE(s.created_date) * 60
        + SECOND(s.created_date) AS created_time_key,

    CAST(DATE_FORMAT(s.closed_date, 'yyyyMMdd') AS INT)
        AS closed_date_key,

    HOUR(s.closed_date) * 3600
        + MINUTE(s.closed_date) * 60
        + SECOND(s.closed_date) AS closed_time_key,

    s.created_date,
    s.closed_date,
    s.status,
    1 AS request_count

FROM {{ ref('hub_service_request') }} h

LEFT JOIN current_requests s
    ON h.hk_service_request_h = s.hk_service_request_h

LEFT JOIN {{ ref('link_service_request_agency') }} l
    ON h.hk_service_request_h = l.hk_service_request_h
