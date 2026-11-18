
{{ config(materialized='view') }}

WITH complaint_details AS (

    SELECT DISTINCT
        complaint_type,
        descriptor
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

)

SELECT
    sha2(
        to_json(named_struct(
            'complaint_type', complaint_type,
            'descriptor', descriptor
        ), map('ignoreNullFields', 'false')),
        256
    ) AS complaint_detail_key,
    complaint_type,
    descriptor

FROM complaint_details
