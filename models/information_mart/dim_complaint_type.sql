
{{ config(materialized='view') }}

WITH complaint_types AS (

    SELECT DISTINCT
        complaint_type
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

)

SELECT
    sha2(complaint_type, 256) AS complaint_type_key,
    complaint_type

FROM complaint_types
