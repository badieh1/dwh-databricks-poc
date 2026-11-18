
{{ config(materialized='view') }}

WITH times AS (

    SELECT EXPLODE(SEQUENCE(0, 86399)) AS second_of_day

)

SELECT
    second_of_day AS time_key,
    CAST(FLOOR(second_of_day / 3600) AS INT) AS hour,
    PMOD(CAST(FLOOR(second_of_day / 60) AS INT), 60) AS minute,
    PMOD(second_of_day, 60) AS second,

    CASE
        WHEN second_of_day < 21600 THEN 'Night'
        WHEN second_of_day < 43200 THEN 'Morning'
        WHEN second_of_day < 64800 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day

FROM times
