SELECT
    "id_observation",
    "subject",
    "focus",
    "code_coding_code",
    "effectiveDateTime",
    "category_text"::VARCHAR
FROM
    {{ ref('osiris_clean_analysis_Observation') }}
UNION
SELECT
    'Unknown-Imagery' AS id_observation,
    NULL AS "subject",
    NULL AS "focus",
    'C37-2' AS "code_coding_code",
    '1000-01-01' AS "effectiveDateTime",
    'C0439673' AS "category_text"
