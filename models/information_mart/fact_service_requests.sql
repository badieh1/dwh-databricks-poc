
{{ config(materialized='view') }}

WITH current_requests AS (

    SELECT
        *,
        TRY_TO_TIMESTAMP(
            created_date, 'MM/dd/yyyy hh:mm:ss a'
        ) AS created_timestamp,
        TRY_TO_TIMESTAMP(
            closed_date, 'MM/dd/yyyy hh:mm:ss a'
        ) AS closed_timestamp

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

    CAST(DATE_FORMAT(s.created_timestamp, 'yyyyMMdd') AS INT)
        AS created_date_key,

    HOUR(s.created_timestamp) * 3600
        + MINUTE(s.created_timestamp) * 60
        + SECOND(s.created_timestamp) AS created_time_key,

    CAST(DATE_FORMAT(s.closed_timestamp, 'yyyyMMdd') AS INT)
        AS closed_date_key,

    HOUR(s.closed_timestamp) * 3600
        + MINUTE(s.closed_timestamp) * 60
        + SECOND(s.closed_timestamp) AS closed_time_key,

    s.created_timestamp AS created_date,
    s.closed_timestamp AS closed_date,
    s.status,
    1 AS request_count

FROM {{ ref('hub_service_request') }} h

LEFT JOIN current_requests s
    ON h.hk_service_request_h = s.hk_service_request_h

LEFT JOIN {{ ref('link_service_request_agency') }} l
    ON h.hk_service_request_h = l.hk_service_request_h
