WITH
researchstudy AS (
    SELECT DISTINCT
        "OSIRIS_pivot_Treatment"."Treatment_ClinicalTrialName" AS "title",
        coalesce(
            "OSIRIS_pivot_Treatment"."Treatment_ClinicalTrialId"::VARCHAR, 'Unknown'
        ) AS "identifier_value"
    FROM
        {{ ref('OSIRIS_pivot_Treatment') }}
)

SELECT DISTINCT
    *,
    'researchstudy_identifier' || row_number() OVER () AS id_researchstudy
FROM
    researchstudy
