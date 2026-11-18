
{{ config(materialized='view') }}

WITH date_bounds AS (

    SELECT
        LEAST(
            MIN(CAST(TRY_TO_TIMESTAMP(created_date, 'MM/dd/yyyy hh:mm:ss a') AS DATE)),
            MIN(CAST(TRY_TO_TIMESTAMP(closed_date, 'MM/dd/yyyy hh:mm:ss a') AS DATE))
        ) AS start_date,
        GREATEST(
            MAX(CAST(TRY_TO_TIMESTAMP(created_date, 'MM/dd/yyyy hh:mm:ss a') AS DATE)),
            MAX(CAST(TRY_TO_TIMESTAMP(closed_date, 'MM/dd/yyyy hh:mm:ss a') AS DATE))
        ) AS end_date
    FROM {{ ref('sat_service_request_v1') }}
    WHERE is_current = true

),

dates AS (

    SELECT EXPLODE(
        SEQUENCE(start_date, end_date, INTERVAL 1 DAY)
    ) AS calendar_date
    FROM date_bounds

)

SELECT
    CAST(DATE_FORMAT(calendar_date, 'yyyyMMdd') AS INT) AS date_key,
    calendar_date,
    YEAR(calendar_date) AS year,
    QUARTER(calendar_date) AS quarter,
    MONTH(calendar_date) AS month,
    DAY(calendar_date) AS day,
    WEEKOFYEAR(calendar_date) AS week_of_year,
    WEEKDAY(calendar_date) + 1 AS day_of_week,
    WEEKDAY(calendar_date) IN (5, 6) AS is_weekend

FROM dates
