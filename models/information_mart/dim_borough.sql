
{{ config(materialized='view') }}

WITH boroughs AS (

    SELECT DISTINCT
        borough
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

)

SELECT
    sha2(borough, 256) AS borough_key,
    borough

FROM boroughs
