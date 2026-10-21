{{ config(materialized='view') }}

{% set load_batch = var('load_batch', 'initial') %}

{% if load_batch == 'initial' %}

    SELECT
        *,
        CAST('2026-10-21 10:00:00' AS TIMESTAMP) AS ldts,
        'NYC_311' AS rsrc
    FROM {{ source('nyc_311', 'nyc_311_initial') }}

{% elif load_batch == 'update_1' %}

    SELECT
        *,
        CAST('2026-10-22 10:00:00' AS TIMESTAMP) AS ldts,
        'NYC_311' AS rsrc
    FROM {{ source('nyc_311', 'nyc_311_update_1') }}

{% else %}

    {{ exceptions.raise_compiler_error(
        "Unbekannter load_batch: " ~ load_batch
    ) }}

{% endif %}
