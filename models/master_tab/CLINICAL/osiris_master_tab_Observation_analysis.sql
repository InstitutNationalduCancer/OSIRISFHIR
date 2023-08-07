SELECT
    "id_observation"::varchar AS id_observation,
    "identifier_value" AS "identifier_value",
    RIGHT("category_coding_code", -POSITION(':' IN "category_coding_code")) AS
    "category_coding_code",
    CASE
        WHEN "code_coding_code" IS NULL THEN 'C0439673'
        ELSE
            RIGHT(
                "code_coding_code"::varchar,
                -POSITION(':' IN "code_coding_code"::varchar)
            )
    END AS "code_coding_code",
    "subject" AS "subject",
    "focus" AS "focus",
    "effectiveDateTime" AS "effectiveDateTime"
FROM
    {{ ref('osiris_clean_analysis_Observation') }}
UNION
SELECT
    'Unknown-Imagery' AS id_observation,
    NULL AS "identifier_value",
    'C37-2' AS "category_coding_code",
    'C0439673' AS "code_coding_code",
    NULL AS "subject",
    NULL AS "focus",
    '1000-01-01' AS "effectiveDateTime"
