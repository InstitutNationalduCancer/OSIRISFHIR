SELECT
    "OSIRIS_pivot_Study"."Study_Location" AS "name",
    'endpoint_identifier' || ROW_NUMBER() OVER () AS id_endpoint
FROM
    {{ ref("OSIRIS_pivot_Study") }}
