{{ config(materialized='view') }}

SELECT
    unique_key,
    agency,
    status,
    created_date
FROM {{ source('nyc_311', 'nyc_311_initial') }}
LIMIT 10
